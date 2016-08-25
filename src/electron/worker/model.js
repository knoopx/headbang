export default class Model {
  constructor(props: Object){
    Object.assign(this, props)
  }

  static emit(action: string, target: Model) {
    process.send({type: this.name, target, action})
    return target
  }

  static inject(target: Model) {
    return this.emit('inject', target)
  }

  static eject(target: Model) {
    return this.emit('eject', target)
  }

  merge(newProps: Object) {
    const {mergeRules} = this.constructor
    return Object.keys(mergeRules).reduce((props, propName) => {
      const value = mergeRules[propName]([props[propName], newProps[propName]])
      props[propName] = value
      return props
    }, new this.constructor(Object.assign({}, this)))
  }
}
