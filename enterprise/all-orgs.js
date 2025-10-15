(function (global) {
  const DEFAULT_WORKER_URL = './all-orgs.worker.js';

  function prepareAllOrgsInScope(nodes, { workerUrl = DEFAULT_WORKER_URL } = {}) {
    return new Promise((resolve, reject) => {
      if (!('Worker' in global)) {
        try {
          const byId = new Map(nodes.map(n => [n.id, n]));
          for (const n of nodes) n.allOrgsInScope = collectDescendantsSync(n.id, byId);
          resolve(nodes);
        } catch (e) { reject(e); }
        return;
      }
      const worker = new Worker(workerUrl); // classic worker
      const idToNode = new Map(nodes.map(n => [n.id, n]));
      worker.onmessage = ({ data }) => {
        if (data && data.type === 'done' && data.result) {
          for (const [id, list] of Object.entries(data.result)) {
            const node = idToNode.get(id);
            if (node) node.allOrgsInScope = list;
          }
          worker.terminate();
          resolve(nodes);
        }
      };
      worker.onerror = (err) => { worker.terminate(); reject(err); };
      worker.postMessage({
        type: 'start',
        nodes: nodes.map(n => ({ id: n.id, children: Array.isArray(n.children) ? n.children : [] }))
      });
    });
  }

  function collectDescendantsSync(rootId, byId) {
    const seen = new Set(), out = [], stack = [rootId];
    while (stack.length) {
      const id = stack.pop();
      if (seen.has(id)) continue;
      seen.add(id); out.push(id);
      const node = byId.get(id);
      if (node && Array.isArray(node.children)) {
        for (let i = node.children.length - 1; i >= 0; i--) {
          const cid = node.children[i];
          if (byId.has(cid)) stack.push(cid);
        }
      }
    }
    return out;
  }

  global.prepareAllOrgsInScope = prepareAllOrgsInScope;
})(window);
