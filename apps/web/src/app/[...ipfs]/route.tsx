export async function GET(req: Request, { params }: any) {
  const path = (params?.ipfs || []).join('/');
  try {
    const resp = await fetch(`https://cloudflare-ipfs.com/ipfs/${path}`);
    if (!resp.ok || !resp.body) {
      return new Response('Unable to fetch IPFS content', { status: 502 });
    }
    return new Response(resp.body, {
      headers: {
        'Content-Type': resp.headers.get('Content-Type') || 'application/octet-stream'
      }
    });
  } catch (err) {
    return new Response('Content unavailable offline', { status: 504 });
  }
}
