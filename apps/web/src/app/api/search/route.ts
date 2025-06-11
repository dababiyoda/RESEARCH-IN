import { NextRequest, NextResponse } from 'next/server';
import { rrfMerge } from '@open-research-nexus/shared';

const TYPESENSE_URL = process.env.TYPESENSE_URL ?? '';
const QDRANT_URL = process.env.QDRANT_URL ?? '';

async function queryTypesense(q: string) {
  if (!TYPESENSE_URL) return [] as any[];
  const res = await fetch(`${TYPESENSE_URL}/search?q=${encodeURIComponent(q)}`);
  const data = await res.json();
  return data.hits?.map((h: any) => ({ id: h.document.id, title: h.document.title })) ?? [];
}

async function queryQdrant(q: string) {
  if (!QDRANT_URL) return [] as any[];
  const res = await fetch(`${QDRANT_URL}/search`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ query: q })
  });
  const data = await res.json();
  return data.result?.map((r: any) => ({ id: r.payload.id, title: r.payload.title })) ?? [];
}

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const q = searchParams.get('q') ?? '';
  if (!q) return NextResponse.json([]);

  const [keywordHits, semanticHits] = await Promise.all([
    queryTypesense(q),
    queryQdrant(q)
  ]);

  const merged = rrfMerge([keywordHits, semanticHits], 60).slice(0, 20);
  return NextResponse.json(merged);
}
