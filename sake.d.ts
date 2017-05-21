interface executive {
  (command: string | any[], options?: any, callback?: any): Promise<any>
  interactive: executive
  parallel: executive
  quiet: executive
  serial: executive
  strict: executive
  sync: (command: string | any[], options?: any, callback?: any) => any
}
declare var exec:    executive
declare var invoke:  (command: string | string[]) => Promise<any>
declare var require: (module: string) => any
declare var task:    (command: string, description: string, ...args: any[]) => void
declare var use:     (plugin:  string) => void
declare var watch:   (path: string, fn: any) => void
