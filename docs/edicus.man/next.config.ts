import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Edicus 에디터 iframe 및 리소스 서버 이미지 허용
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "resource-dot-edicusbase.appspot.com",
        pathname: "/**",
      },
      {
        protocol: "https",
        hostname: "edicusbase.firebaseapp.com",
        pathname: "/**",
      },
    ],
  },

  // Edicus SDK iframe 로드를 위한 보안 헤더
  async headers() {
    return [
      {
        // API 라우트에 CORS 헤더 적용
        source: "/api/:path*",
        headers: [
          { key: "Access-Control-Allow-Credentials", value: "true" },
          { key: "Access-Control-Allow-Origin", value: process.env.NEXT_PUBLIC_EDICUS_BASE_URL ?? "*" },
          { key: "Access-Control-Allow-Methods", value: "GET,POST,PUT,DELETE,OPTIONS" },
          { key: "Access-Control-Allow-Headers", value: "Content-Type, Authorization" },
        ],
      },
    ];
  },
};

export default nextConfig;
