declare var exec:    (command: string | any[], options?: any, callback?: any) => void
declare var invoke:  (command: string | string[]) => void
declare var require: (module: string)  => any
declare var task:    (command: string, description: string, ...args: any[]) => void
declare var use:     (plugin:  string) => void
declare var watch:   (path: string, fn: any) => void
