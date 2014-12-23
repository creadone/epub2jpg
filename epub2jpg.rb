#run script from dir with *.epub (name: 763254_epub.epub)

require "in_threads"

CALIBRE = '/Applications/calibre.app/Contents/MacOS/ebook-convert ' #calibre-ebook.com
CONVERT = 'convert' #imagemagick
PAGETOPREVIEW = 10 #in %
THREADSNUM = 20
sourceBooks = Dir.glob('*.epub').sort!

def getBookID (filename)
  id = filename.split("_")
  return id[0].to_s
end

def removeExtraFiles (pathToJPG)
  jpgList = Dir.glob("#{pathToJPG}/jpg/*.jpg")
  jpgList.sort!
  pageCount = (jpgList.length.to_i * PAGETOPREVIEW) / 100
  if pageCount < 3
    pageCount = 3
  elsif pageCount > 10
    pageCount = 10
  end
  for i in pageCount.round..jpgList.length-1 # <- wtf?
    File.delete(jpgList[i])
  end
end

def getBookPreview (bookname)
  unless File.directory?(getBookID(bookname))
    system('mkdir -p '+getBookID(bookname)+'/jpg/')
    print "\nDirs #{getBookID(bookname)}/jpg/ for images done\n\n"
    system('chmod 777 '+getBookID(bookname)+'/jpg/')
    print "Rights is assigned\n\n"
    print "Converting #{getBookID(bookname)}: epub -> pdf...\n\n"
    system(CALIBRE+bookname+' '+getBookID(bookname)+'/'+getBookID(bookname)+'.pdf'+' --extra-css styles/style.css >>calibre_log.txt 2>&1')
    print "epub to #{getBookID(bookname)}.pdf converted\n\n"
    print "#{getBookID(bookname)}: create images for preview...\n\n"
    system(CONVERT+' -scale 2000x1000 -quality 100 -density 72 -bordercolor white -border 10 '+getBookID(bookname)+'/'+getBookID(bookname)+'.pdf '+getBookID(bookname)+'/jpg/'+getBookID(bookname)+"_%03d.jpg"+" >>convert_log.txt 2>&1")
    print "#{getBookID(bookname)}: images for all pages is done\n\n"
    removeExtraFiles(getBookID(bookname))
    print "Preview for book #{getBookID(bookname)} is done\n\n"
  end
end

sourceBooks.in_threads(THREADSNUM).map do |file|
    getBookPreview(file)
end

