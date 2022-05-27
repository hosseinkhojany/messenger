
//import imageCompression from 'browser-image-compression';
//const imageCompression = require('browser-image-compression');

//import Compressor from 'compressorjs';

function comp(base64) {
    var url = base64;

    fetch(url)
        .then(res => res.blob())
        .then(blob => {
            var imageFile = blob;
            console.log('originalFile instanceof Blob', imageFile instanceof Blob); // true
            console.log(`originalFile size ${imageFile.size / 1024 / 1024} MB`);

            var options = {
                maxSizeMB: 0.2,//right now max size is 200kb you can change
                maxWidthOrHeight: 1920,
                useWebWorker: true
            }
            imageCompression(imageFile, options)
                .then(function (compressedFile) {
                    console.log('compressedFile instanceof Blob', compressedFile instanceof Blob); // true
                    console.log(`compressedFile size ${compressedFile.size / 1024 / 1024} MB`); // smaller than maxSizeMB
                    console.log(compressedFile.type);
                    console.log(compressedFile.text());
                })
                .catch(function (error) {
                    console.log(error.message);
                });
        })

}