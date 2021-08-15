const userId = document.getElementById('userId').innerHTML
const username = document.getElementById('username').innerHTML
const alertBox = document.getElementById('alert-box')
const imageBox = document.getElementById('image-box')
const imageForm = document.getElementById('image-form')
const confirmBtn = document.getElementById('confirm-btn')
const input = document.getElementById('id_file')
var redirect = '';
var redirect_success = `/${userId}/profile`;

        input.addEventListener('change', ()=>{
            alertBox.innerHTML = ""
            confirmBtn.classList.remove('not-visible')
            const img_data = input.files[0]
            const url = URL.createObjectURL(img_data)

            imageBox.innerHTML = `<img src="${url}" id="image" width="700px" height="700px">`
            var $image = $('#image')

            $image.cropper({
                aspectRatio: 9 / 9,
                crop: function(event) {
                    // console.log(event.detail.x);
                    // console.log(event.detail.y);
                    // console.log(event.detail.width);
                    // console.log(event.detail.height);
                    // console.log(event.detail.rotate);
                    // console.log(event.detail.scaleX);
                    // console.log(event.detail.scaleY);
                }
            });
            
            var cropper = $image.data('cropper');

            confirmBtn.addEventListener('click', ()=>{
                cropper.getCroppedCanvas().toBlob((blob) => {
                    const fd = new FormData();
                    fd.append('profilePicture', blob, `${userId}-${username}.jpg`);

                    $.ajax({
                        type:'POST',
                        url: `/${userId}/profile/editprofpic`,
                        enctype: 'multipart/form-data',
                        data: fd,
                        success: function(response){
                            window.location.href = `/${userId}/profile`;
                        },
                        error: function(error){
                            alertBox.innerHTML = `<div class="alert alert-danger" role="alert">
                                                        Ups...something went wrong
                                                    </div>`
                        },
                            cache: false,
                            contentType: false,
                            processData: false,
                        })
                    })
                })

        })    