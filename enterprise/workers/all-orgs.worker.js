// all-orgs.worker.js
/* Expects: postMessage({ type: 'start', nodes: [{ id, children: [...] }, ...] })
   Returns: postMessage({ type: 'done', result: { [id]: [ids...] } })
*/

self.onmessage = ({ data }) => {
  if (!data || data.type !== 'start' || !Array.isArray(data.nodes)) return;
  const nodesIn = data.nodes;

  // Build lookups
  const idToNode = new Map();
  for (const n of nodesIn) {
    idToNode.set(n.id, { id: n.id, children: Array.isArray(n.children) ? n.children : [] });
  }

  const n = nodesIn.length;
  const idToIdx = new Map();
  const idxToId = new Array(n);
  let i = 0;
  for (const n0 of nodesIn) {
    idToIdx.set(n0.id, i);
    idxToId[i] = n0.id;
    i++;
  }

  // Typed array stamp trick to dedupe without allocating Sets in tight loops
  const stamp = new Uint32Array(n);
  let stampId = 1;

  // Memo: id -> array of all descendants (including self)
  const memo = new Map();

  // Iterative, cycle-safe post-order compute for a single id
  function computeFor(id) {
    if (memo.has(id)) return memo.get(id);

    // DFS stack with per-frame child index
    const stack = [{ id, ci: 0 }];
    const inStack = new Set([id]); // cycle guard
    const post = [];               // nodes in post-order for this subtree

    while (stack.length) {
      const frame = stack[stack.length - 1];
      const node = idToNode.get(frame.id);
      const children = node ? node.children : [];

      if (frame.ci < children.length) {
        const childId = children[frame.ci++];
        if (!idToNode.has(childId)) continue; // skip missing
        if (!memo.has(childId) && !inStack.has(childId)) {
          stack.push({ id: childId, ci: 0 });
          inStack.add(childId);
        }
        // If already memoised or would form a cycle, we just continue
      } else {
        post.push(frame.id);
        inStack.delete(frame.id);
        stack.pop();
      }
    }

    // Build closures bottom-up using stamp-based dedupe
    for (const nid of post) {
      const node = idToNode.get(nid);
      const children = node ? node.children : [];
      const sid = stampId++;
      const acc = [];

      const selfIdx = idToIdx.get(nid);
      if (selfIdx !== undefined) {
        stamp[selfIdx] = sid;
        acc.push(nid); // include self
      }

      for (const cId of children) {
        const childList = memo.get(cId) || [cId];
        for (let k = 0; k < childList.length; k++) {
          const cid = childList[k];
          const idx = idToIdx.get(cid);
          if (idx !== undefined && stamp[idx] !== sid) {
            stamp[idx] = sid;
            acc.push(cid);
          }
        }
      }
      memo.set(nid, acc);
    }

    return memo.get(id);
  }

  // Compute for all nodes (memo ensures each subtree is processed once)
  const result = Object.create(null);
  for (const n0 of nodesIn) {
    result[n0.id] = computeFor(n0.id);
  }

  postMessage({ type: 'done', result });
};
