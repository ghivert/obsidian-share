const cache = {}

const styleSheet = (() => {
  const styleEl = document.createElement('style')
  // Append <style> element to <head>
  document.head.appendChild(styleEl)
  // Grab style element's sheet
  return styleEl.sheet
})()

function getCallingFunction() {
  const error = new Error()
  if (!error.stack) throw new Error('Unable to find the stacktrace and to infer the className')
  const lines = error.stack.split('\n')
  const isMatch = lines[3].match(/at ([a-zA-Z0-9_-]*) .*/)
  if (!isMatch) throw new Error('Unable to find the stacktrace and to infer the className')
  return isMatch[1]
}

const idt = indent => ' '.repeat(indent)

function computeProperties(rawProperties, indent = 2) {
  const properties = rawProperties.toArray()
  const init = { lines: [], medias: [], classes: [], indent }
  return properties.reduce(({ lines, medias, classes, indent }, property) => {
    const baseIndent = idt(indent)
    if ('class_name' in property) {
      return { lines, medias, classes: [...classes, property.class_name], indent }
    }
    if ('key' in property && 'value' in property) {
      const cssProperty = `${baseIndent}${property.key}: ${property.value};`
      return { lines: [...lines, cssProperty], medias, classes, indent }
    }
    if ('query' in property && 'styles' in property) {
      const { query, styles } = property
      const computedProperties = computeProperties(styles, 4)
      return {
        lines,
        medias: [{ query, properties: computedProperties.lines }, ...computedProperties.medias],
        classes: [...classes, ...computedProperties.classes],
        indent,
      }
    }
    return { lines, medias, classes, indent }
  }, init)
}

export function compileClass(args) {
  const callingClass = getCallingFunction()
  if (cache[callingClass]) return cache[callingClass]

  cache[callingClass] = (function () {
    const { lines: cssProperties, medias, classes } = computeProperties(args)
    const wrapClass = (properties, indent) => {
      const baseIndent = idt(indent)
      return [`${baseIndent}.${callingClass} {`, ...properties, `${baseIndent}}`].join('\n')
    }
    const classDef = wrapClass(cssProperties, 0)
    const mediasDef = medias.map(({ query, properties }) => {
      return [`${query} {`, wrapClass(properties, 2), '}'].join('\n')
    })
    styleSheet.insertRule(classDef)
    mediasDef.forEach(def => styleSheet.insertRule(def))
    const finalClasses = `${classes.join(' ')} ${callingClass}`

    return finalClasses
  })()

  return cache[callingClass]
}

export function toString(className) {
  return className
}
