declare var exec:    (command: string | any[], options?: any, callback?: any) => Promise<any>
declare var invoke:  (command: string | string[]) => Promise<any>
declare var require: (module: string) => any
declare var task:    (command: string, description: string, ...args: any[]) => void
declare var use:     (plugin:  string) => void
declare var watch:   (path: string, fn: any) => void
