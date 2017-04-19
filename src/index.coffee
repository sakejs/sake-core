import * as sake from './sake'
import {version} from '../package.json'

sake.version = version

export * from './sake'
export {version}
export default sake
