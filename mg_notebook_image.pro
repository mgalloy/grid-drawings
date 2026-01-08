pro mg_notebook_image, image_filename, rotate=rotate
  compile_opt strictarr

  notebook_dims = [24, 40]
  ;notebook_dims = [240, 400]

  im = read_image(image_filename)

  im = mean(float(im), dimension=1)
  im = rotate(im, mg_default(rotate, 0))
  original_im = im
  dims = size(im, /dimensions)

  notebook_aspect_ratio = float(notebook_dims[1]) / float(notebook_dims[0])
  aspect_ratio = float(dims[1]) / float(dims[0])

  if (aspect_ratio lt notebook_aspect_ratio) then begin
    y = (dims[1] - 1.0) / 2.0
    x = y / notebook_aspect_ratio
  endif else begin
    x = (dims[0] - 1.0) / 2.0
    y = notebook_aspect_ratio * x
  endelse

  center = (float(dims) - 1.0) / 2.0
  im = im[center[0] - x:center[0] + x, center[1] - y:center[1] + y]
  im = congrid(im, notebook_dims[0], notebook_dims[1])
  im = byte(im)

  factor = 20L
  original_im = congrid(original_im, notebook_dims[0] * factor, notebook_dims[1] * factor)

  mg_image, congrid((im / 32B) * 32B, notebook_dims[0] * factor, notebook_dims[1] * factor), /new
  mg_image, original_im, /new

  im = 255B - reverse(im, 2)
  im = im / 32B

  print, im

  for i = 0, 7 do begin
    !null = where(im eq i, count)
    print, i, count, format='%d: %d pixels'
  endfor
end


; main-level example program

;filename = 'IMG_5318.jpeg'
;filename = 'IMG_7942.jpeg'
filename = 'IMG_7952.jpeg'
mg_notebook_image, filename, rotate=0

end


