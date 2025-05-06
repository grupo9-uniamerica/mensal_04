"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
//teste
export default function Page() {
  const router = useRouter();

  useEffect(() => {
    router.push("/home");
  }, [router]);
}