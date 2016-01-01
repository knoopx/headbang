{expect} = require("chai")
Support = require("../../src/common/support")

describe 'Support', ->
  describe 'normalize', ->
    it "normalizes 'and'", ->
      expect(Support.normalize("Drum & Bass")).to.deep.eq("Drum and Bass")
      expect(Support.normalize("Drum'n'Bass")).to.deep.eq("Drum and Bass")
      expect(Support.normalize("Drum n Bass")).to.deep.eq("Drum and Bass")
      expect(Support.normalize("Satán Vive")).to.deep.eq("Satán Vive")

    it "normalizes spaces", ->
      expect(Support.normalize(" album   title ")).to.deep.eq("album title")

    it "strips out () and []", ->
      expect(Support.normalize("Album Title (Notes)")).to.deep.eq("Album Title")
      expect(Support.normalize("Album Title [Notes]")).to.deep.eq("Album Title")
      expect(Support.normalize("Album Title (Notes")).to.deep.eq("Album Title")
      expect(Support.normalize("Album Title [Notes")).to.deep.eq("Album Title")

    it "strips out non-word chars", ->
      expect(Support.normalize(" - album title")).to.deep.eq("album title")
      expect(Support.normalize("album title - ")).to.deep.eq("album title")
      expect(Support.normalize("_--album title")).to.deep.eq("album title")
      expect(Support.normalize("album title_--_")).to.deep.eq("album title")

  describe "normalizeAlbumName", ->
    it "false positives", ->
      expect(Support.normalizeAlbumName("Satán Vive")).to.deep.eq("Satán Vive")

    it "normalizes spaces", ->
      expect(Support.normalizeAlbumName("Album_Title")).to.deep.eq("Album Title")

    it "strips () and []", ->
      expect(Support.normalizeAlbumName("Album Title (Notes)")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title [Notes]")).to.deep.eq("Album Title")

    it "strips catalog number", ->
      expect(Support.normalizeAlbumName("Album Title-NUM001 Vinyl")).to.deep.eq("Album Title")

    it "strips references", ->
      expect(Support.normalizeAlbumName("Album Title EP")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title 7 Inch")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title 7 Inch Vinyl")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title 7\"")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title 7i")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title 7-inch")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title 7_inch")).to.deep.eq("Album Title")
      expect(Support.normalizeAlbumName("Album Title (7\")")).to.deep.eq("Album Title")

  describe "normalizeArtistName", ->
    it "strips () and []", ->
      expect(Support.normalizeArtistName("artist (1)")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist [1]")).to.deep.eq(["artist"])

    it "strips featuring", ->
      expect(Support.normalizeArtistName("artist presents artist")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist ft artist")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist ft. artist")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist ft.artist")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist feat artist")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist feat. artist")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist feat.artist")).to.deep.eq(["artist"])
      expect(Support.normalizeArtistName("artist featartist")).to.deep.eq(["artist featartist"])

  describe "parseGenre", ->
    it "normalizes values when matching", ->
      expect(Support.parseGenre("Drum n Bass")).to.deep.eq("Drum & Bass")
      expect(Support.parseGenre("Drum'n'Bass")).to.deep.eq("Drum & Bass")
      expect(Support.parseGenre("Drum and Bass")).to.deep.eq("Drum & Bass")
