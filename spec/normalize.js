import {expect} from 'chai'
import {albumName, artistName, genre, tags} from '../src/electron/worker/normalize'

expect(artistName('a & b')).to.eq('a and b')
expect(artistName('a feat. b')).to.eq('a')

expect(albumName('album name read nfo')).to.eq('album name')
expect(albumName('st')).to.eq('Self-Titled')
expect(albumName('s.t.')).to.eq('Self-Titled')
expect(albumName('s t')).to.eq('Self-Titled')
expect(albumName('s-t')).to.eq('Self-Titled')

expect(albumName('Self Titled EP')).to.eq('Self-Titled')
expect(albumName('EP')).to.eq('EP')
expect(albumName('7 inch EP')).to.eq('EP')
expect(genre('rock n roll')).to.eq('Rock & Roll')

expect(tags('reissue')).to.include('Reissue')
expect(tags('7 inch vinyl')).to.include('Vinyl')
expect(tags('7 inch cds')).to.include('CD', 'Single')
