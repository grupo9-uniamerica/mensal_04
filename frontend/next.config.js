/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  async rewrites() {
    const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL;  // Acessando a variável de ambiente
    const appUrl = process.env.NEXT_PUBLIC_APP_URL;           // Acessando a variável de ambiente

    return {
      beforeFiles: [
        {
          source: '/api/rooms',
          destination: `${backendUrl}/rooms/`,
        },
        {
          source: '/api/rooms/:path*',
          destination: `${backendUrl}/rooms/:path*/`,  // Usando a URL do backend
        },
        {
          source: '/api/reservations/:path*',
          destination: `${backendUrl}/reservations/:path*/`,  // Usando a URL do backend
        },
        {
          source: '/api/token',
          destination: `${backendUrl}/token/`,  // Usando a URL do backend
        },
        {
          source: '/token',
          destination: `${backendUrl}/token/`,  // Usando a URL do backend
        },
      ],
    };
  },
};

module.exports = nextConfig;
