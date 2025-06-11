import { useEffect, useState } from 'react';

export default function CommandPalette() {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<any[]>([]);

  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if ((e.key === 'k' || e.key === 'K') && (e.metaKey || e.ctrlKey)) {
        e.preventDefault();
        setOpen(prev => !prev);
      }
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, []);

  useEffect(() => {
    if (!query) { setResults([]); return; }
    const controller = new AbortController();
    fetch(`/api/search?q=${encodeURIComponent(query)}`, { signal: controller.signal })
      .then(res => res.json())
      .then(setResults)
      .catch(() => {});
    return () => controller.abort();
  }, [query]);

  if (!open) return null;
  return (
    <div style={{position:'fixed',inset:0,background:'rgba(0,0,0,0.3)'}}>
      <div style={{background:'white',margin:'10% auto',padding:20,width:400}}>
        <input
          autoFocus
          value={query}
          onChange={e => setQuery(e.target.value)}
          placeholder="Search"
          style={{width:'100%'}}
        />
        <ul>
          {results.map((r:any) => (
            <li key={r.id}>{r.title || r.id}</li>
          ))}
        </ul>
      </div>
    </div>
  );
}
