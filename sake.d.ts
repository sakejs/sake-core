/// <reference types="node" />

/// <reference types="executive" />
declare var exec: executive

declare var invoke:  (command: string | string[]) => Promise<any>
declare var task:    (command: string, description: string, ...args: any[]) => void
declare var use:     (plugin:  string) => void
declare var watch:   (path: string, fn: any) => void
