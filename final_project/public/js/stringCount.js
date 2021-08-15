let inputTextArea = document.getElementById("input-textarea");
let characCount = document.getElementById("charac-count");

inputTextArea.addEventListener("input", () => {
    characCount.textContent = inputTextArea.value.length;
    if (inputTextArea.value.length > 1000){
        document.getElementById("submitBtn").disabled=true;
    } else {
        document.getElementById("submitBtn").disabled=false;
    }
});