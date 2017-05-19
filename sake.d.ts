declare var exec:    (command: string) => void
declare var invoke:  (command: string) => void
declare var require: (module: string)  => any
declare var task:    (command: string, description: string, ...args: any[]) => void
declare var use:     (plugin:  string) => void
declare var watch:   (path: string, fn: any) => void
