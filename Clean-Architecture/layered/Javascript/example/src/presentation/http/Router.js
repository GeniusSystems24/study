export class Router {
  constructor() {
    this.routes = [];
  }

  register(method, pattern, handler) {
    const keys = [];
    const expression = pattern.replace(/:([A-Za-z0-9_]+)/g, (_match, key) => {
      keys.push(key);
      return "([^/]+)";
    });
    this.routes.push({
      method: method.toUpperCase(),
      regex: new RegExp(`^${expression}$`),
      keys,
      handler
    });
  }

  match(method, path) {
    for (const route of this.routes) {
      if (route.method !== method.toUpperCase()) continue;
      const match = path.match(route.regex);
      if (!match) continue;
      const params = Object.fromEntries(
        route.keys.map((key, index) => [key, decodeURIComponent(match[index + 1])])
      );
      return { handler: route.handler, params };
    }
    return null;
  }
}
