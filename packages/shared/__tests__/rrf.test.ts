import { rrfMerge } from '../rrf';

test('rrfMerge merges rankings with k=60', () => {
  const listA = [{ id: 'a' }, { id: 'b' }, { id: 'c' }];
  const listB = [{ id: 'b' }, { id: 'c' }, { id: 'a' }];
  const result = rrfMerge([listA, listB], 60);
  const ids = result.slice(0,3).map(r => r.id);
  expect(ids).toEqual(['b','a','c']);
});
