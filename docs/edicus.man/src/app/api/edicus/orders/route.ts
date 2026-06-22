// Edicus 주문 API 라우트
// POST /api/edicus/orders - 주문 생성 (잠정/확정)
// DELETE /api/edicus/orders - 주문 취소
// @MX:ANCHOR: 주문 관리 API - POST/DELETE 핸들러
// @MX:REASON: 주문 프로세스의 핵심 엔드포인트로 useOrder 훅에서 호출됨
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { createServerApiClient } from '@/lib/edicus/server-api';

// 주문 생성 요청 바디 스키마
const CreateOrderBodySchema = z.object({
  projectId: z.string().min(1, 'projectId는 필수입니다'),
  type: z.enum(['tentative', 'definitive'], {
    errorMap: () => ({ message: 'type은 tentative 또는 definitive여야 합니다' }),
  }),
});

// 주문 취소 요청 바디 스키마
const CancelOrderBodySchema = z.object({
  orderId: z.string().min(1, 'orderId는 필수입니다'),
});

// POST /api/edicus/orders - 주문 생성 (잠정 또는 확정)
export async function POST(request: NextRequest): Promise<NextResponse> {
  try {
    const body: unknown = await request.json();
    const parsed = CreateOrderBodySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { projectId, type } = parsed.data;
    const client = createServerApiClient();

    const order =
      type === 'tentative'
        ? await client.tentativeOrder(projectId)
        : await client.definitiveOrder(projectId);

    return NextResponse.json(order, { status: 201 });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

// DELETE /api/edicus/orders - 주문 취소 (잠정 주문만 취소 가능)
export async function DELETE(request: NextRequest): Promise<NextResponse> {
  try {
    const body: unknown = await request.json();
    const parsed = CancelOrderBodySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { orderId } = parsed.data;
    const client = createServerApiClient();
    await client.cancelOrder(orderId);

    return new NextResponse(null, { status: 204 });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
