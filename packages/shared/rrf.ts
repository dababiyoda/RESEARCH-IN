export interface DocumentWithId {
  id: string | number;
  [key: string]: any;
}

export function rrfMerge(lists: DocumentWithId[][], k = 60): DocumentWithId[] {
  const scores = new Map<string | number, number>();
  const docs = new Map<string | number, DocumentWithId>();

  for (const list of lists) {
    for (let i = 0; i < list.length; i++) {
      const doc = list[i];
      const id = doc.id;
      const score = 1 / (k + i + 1);
      scores.set(id, (scores.get(id) || 0) + score);
      if (!docs.has(id)) {
        docs.set(id, doc);
      }
    }
  }

  return Array.from(scores.entries())
    .sort((a, b) => b[1] - a[1])
    .map(([id]) => docs.get(id)!)
}
