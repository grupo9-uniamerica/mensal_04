/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: '/rooms/:path*',
        destination: 'http://backend.frontend.svc.cluster.local:8080/rooms/:path*',
      },
      {
        source: '/token',
        destination: 'http://backend.frontend.svc.cluster.local:8080/token',
      },
      {
        source: '/reservations/:path*',
        destination: 'http://backend.frontend.svc.cluster.local:8080/reservations/:path*',
      },
    ];
  },
};

export default nextConfig; 