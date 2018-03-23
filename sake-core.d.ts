///<reference types="node"/>

import executive from 'executive'

declare global {
  var exec:   executive
  var invoke: (command: string | string[]) => Promise<any>
  var task:   (command: string, description: string, ...args: any[]) => void
  var use:    (plugin:  string, options?: any) => void
  var watch:  (path: string, fn: any) => void
}
