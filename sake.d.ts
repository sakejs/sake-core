declare var exec:    (command: string) => void
declare var invoke:  (command: string) => void
declare var require: (module: string)  => any
declare var use:     (plugin:  string) => void
declare var watch:   (path: string, fn: any) => void
declare var task:    (command: string, description: string, dependency?: string[], fn?: any) => void
