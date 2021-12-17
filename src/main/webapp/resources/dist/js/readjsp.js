/**
 * 
 */

$(document).ready(function () {
	alert("Hi");
    var formObj = $("form[role='form']");
    console.log(formObj);

    $("#modBtn").on("click", function () {
        formObj.attr("action", "${path}/article/modify");
        formObj.attr("method", "get");
        formObj.submit();
    });

    $("#delBtn").on("click", function () {
       formObj.attr("action", "${path}/article/remove");
       formObj.submit();
    });

    $("#listBtn").on("click", function () {
       self.location = "${path}/article/list"
    });

});