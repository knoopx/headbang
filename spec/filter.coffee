{expect} = require("chai")
filter = require("../src/client/filter")

describe 'filter', ->
  it "filter([a: 1, b: 2])(a: 1)", ->
    expect(filter([{a: 1}, {b: 2}])(a: 1)).to.deep.equal([a: 1])

  it "filter([a: 1, b: 2])(a: 2)", ->
    expect(filter([{a: 1}, {b: 2}])(a: 2)).to.deep.equal([])

  it "filter([a: \"HELLO WORLD\"])(a: \"hello\")", ->
    expect(filter([a: "HELLO WORLD"])(a: "hello")).to.deep.equal([a: "HELLO WORLD"])

  it "filter([a: [1, 2]])(a: 1)", ->
    expect(filter([a: [1, 2]])(a: 1)).to.deep.equal([a: [1, 2]])

  it "'' matches 'whatever'", ->
    expect(filter([a: 'whatever'])(a: '')).to.deep.equal([a: 'whatever'])

  it "null matches 'whatever'", ->
    expect(filter([a: 'whatever'])(a: null)).to.deep.equal([a: 'whatever'])

  it "{a: undefined} matches {a: true}", ->
    expect(filter([a: true])(a: undefined)).to.deep.equal([a: true])

  it "", ->
    expect(filter([artistName: ["Ampere"]])(artistName: "ampere")).to.deep.equal([artistName: ["Ampere"]])

  it "", ->
    expect(filter([artistName: ["Ampere"]])(artistName: "hot cross")).to.deep.equal([])
