import { BitArray, CustomType, List, UtfCodepoint } from './gleam.mjs'

export function toString(data) {
  return inspect(data)
}

export function inspect(v) {
  const t = typeof v
  if (v === true) return 'True'
  if (v === false) return 'False'
  if (v === null) return '//js(null)'
  if (v === undefined) return 'Nil'
  if (t === 'string') return JSON.stringify(v)
  if (t === 'bigint' || t === 'number') return v.toString()
  if (Array.isArray(v)) return `#(${v.map(inspect).join(', ')})`
  if (v instanceof List) return inspectList(v)
  if (v instanceof UtfCodepoint) return inspectUtfCodepoint(v)
  if (v instanceof BitArray) return inspectBitArray(v)
  if (v instanceof CustomType) return inspectCustomType(v)
  if (v instanceof Dict) return inspectDict(v)
  if (v instanceof Set) return `//js(Set(${[...v].map(inspect).join(', ')}))`
  if (v instanceof RegExp) return `//js(${v})`
  if (v instanceof Date) return `//js(Date("${v.toISOString()}"))`
  if (v instanceof Function) {
    const args = []
    for (const i of Array(v.length).keys()) args.push(String.fromCharCode(i + 97))
    return `//fn(${args.join(', ')}) { ... }`
  }
  return inspectObject(v)
}

function inspectDict(map) {
  let body = 'dict.from_list(['
  let first = true
  map.forEach((value, key) => {
    if (!first) body = body + ', '
    body = body + '#(' + inspect(key) + ', ' + inspect(value) + ')'
    first = false
  })
  return body + '])'
}

function inspectObject(v) {
  const name = Object.getPrototypeOf(v)?.constructor?.name || 'Object'
  const props = []
  for (const k of Object.keys(v)) {
    props.push(`${inspect(k)}: ${inspect(v[k])}`)
  }
  const body = props.length ? ' ' + props.join(', ') + ' ' : ''
  const head = name === 'Object' ? '' : name + ' '
  return `//js(${head}{${body}})`
}

function inspectCustomType(record) {
  const props = Object.keys(record)
    .map(label => {
      const value = inspect(record[label])
      return isNaN(parseInt(label)) ? `${label}: ${value}` : value
    })
    .join(', ')
  return props ? `${record.constructor.name}(${props})` : record.constructor.name
}

export function inspectList(list) {
  return `[${list.toArray().map(inspect).join(', ')}]`
}

export function inspectBitArray(bits) {
  return `<<${Array.from(bits.buffer).join(', ')}>>`
}

export function inspectUtfCodepoint(codepoint) {
  return `//utfcodepoint(${String.fromCodePoint(codepoint.value)})`
}

export function bit_array_inspect(bits) {
  return `<<${[...bits.buffer].join(', ')}>>`
}
