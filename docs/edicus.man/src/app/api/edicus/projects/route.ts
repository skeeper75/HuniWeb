// Edicus 프로젝트 API 라우트
// GET /api/edicus/projects?uid={uid} - 프로젝트 목록 조회
// POST /api/edicus/projects - 프로젝트 복제
// DELETE /api/edicus/projects - 프로젝트 삭제
// @MX:ANCHOR: 프로젝트 관리 API - GET/POST/DELETE 핸들러
// @MX:REASON: 프로젝트 CRUD 작업의 중앙 진입점으로 다수의 페이지/컴포넌트에서 호출됨
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { createServerApiClient } from '@/lib/edicus/server-api';

// 쿼리 파라미터 스키마 (목록 조회)
const GetProjectsQuerySchema = z.object({
  uid: z.string().min(1, 'uid 파라미터는 필수입니다'),
});

// 요청 바디 스키마 (복제)
const CloneProjectBodySchema = z.object({
  projectId: z.string().min(1, 'projectId는 필수입니다'),
});

// 요청 바디 스키마 (삭제)
const DeleteProjectBodySchema = z.object({
  projectId: z.string().min(1, 'projectId는 필수입니다'),
});

// GET /api/edicus/projects - uid의 프로젝트 목록 조회
export async function GET(request: NextRequest): Promise<NextResponse> {
  try {
    const { searchParams } = request.nextUrl;
    const query = { uid: searchParams.get('uid') ?? '' };
    const parsed = GetProjectsQuerySchema.safeParse(query);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { uid } = parsed.data;
    const client = createServerApiClient();
    const projects = await client.getProjects(uid);

    return NextResponse.json(projects);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

// POST /api/edicus/projects - 프로젝트 복제
export async function POST(request: NextRequest): Promise<NextResponse> {
  try {
    const body: unknown = await request.json();
    const parsed = CloneProjectBodySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { projectId } = parsed.data;
    const client = createServerApiClient();
    const cloned = await client.cloneProject(projectId);

    return NextResponse.json(cloned, { status: 201 });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

// DELETE /api/edicus/projects - 프로젝트 삭제
export async function DELETE(request: NextRequest): Promise<NextResponse> {
  try {
    const body: unknown = await request.json();
    const parsed = DeleteProjectBodySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { projectId } = parsed.data;
    const client = createServerApiClient();
    await client.deleteProject(projectId);

    return new NextResponse(null, { status: 204 });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
