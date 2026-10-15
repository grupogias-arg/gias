# Imágenes de ejemplo para los seeds

Acá van fotos sueltas **solo para poder ver el sitio armado** mientras el grupo
termina de organizar el material. No es contenido definitivo: igual que el resto
de `db/seeds.rb`, esto es relleno.

Al correr `bin/rails db:seed`, lo que haya en estas carpetas se adjunta a los
registros de ejemplo. Si una carpeta está vacía, esa sección simplemente queda
sin fotos y el sitio sigue funcionando (hay placeholders en las vistas).

## Cómo nombrar los archivos

**No hace falta saber qué foto va con qué registro.** Se adjuntan por orden
alfabético de nombre de archivo, así que alcanza con numerarlas:

```
portada/     1.jpg  2.jpg  3.jpg        → rotan en la portada (2 o 3)
equipo/      1.jpg  2.jpg  3.jpg  4.jpg → una por integrante, en orden de listado
proyectos/   1.jpg  2.jpg  3.jpg        → una por proyecto, en orden
campanas/    1.jpg  2.jpg  3.jpg  4.jpg → de a dos por campaña (1+2, 3+4, 5+6)
logo/        logo.svg  (o logo.png)     → reemplaza el placeholder del menú
```

Formatos: `.jpg`, `.jpeg`, `.png`, `.webp`, `.avif`. Para el logo también `.svg`.

No importa el peso: las fotos de cámara vienen de 6 MB y Active Storage genera
variantes chicas para el celular. Podés tirar los originales tal cual.

## Cuando llegue el material de verdad

Esto se borra. Las imágenes reales se cargan desde el panel de administración,
no desde seeds: el grupo va a subir y cambiar fotos sin tocar el código.

## Por qué no están en git

Son archivos pesados de un Drive ajeno y no son contenido aprobado. `.gitignore`
ignora todo lo que haya acá salvo este README.
