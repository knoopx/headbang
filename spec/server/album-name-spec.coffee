{expect} = require("chai")
AlbumName = require("../../src/server/support/album-name")

describe 'Array', ->
  it "#strip()", ->
    for example in ["Album Title 7 Inch", "Album Title 7 Inch Vinyl", "Album Title 7_Inch", "Album Title (Vinyl)"]
      expect(AlbumName.strip(example)).to.equal "Album Title"

  describe '#tags()', ->
    it "parses vinyl", -> expect(AlbumName.tags("Album Title 7 Inch")).to.include "VINYL"
    it "parses vinyl", -> expect(AlbumName.tags("Album Title")).not.to.include "VINYL"
