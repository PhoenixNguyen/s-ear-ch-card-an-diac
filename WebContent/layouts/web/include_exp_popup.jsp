<%@ page language="java" trimDirectiveWhitespaces="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
    function checkExpData() {
        $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/exp/ajax.html',
            data: 'uid=exp',
            error: function (xhr, ajaxOptions, thrownError) {
            },
            success: function (data) {
                if (data != '') {
                	expPopUp(data)
                }
            }
        });
    }
    function expPopUp(value) {
        $('#exp_point_plus').html(value)
        $("#exp_pop").animate({
            bottom: "+=600px",
            opacity: "show"
        }, 3000, function () {
            $(this).css('bottom', '10px').hide();
        });
    }
    $(function () {
        setInterval(function () {
            return checkExpData();
        }, 1000);
    })
</script>

<div id="exp_pop">
    <img src="<%=request.getContextPath() %>/images/exp_point_plus.png"> +<span id="exp_point_plus">0</span>
</div>
<style>
    #exp_pop {
        position: absolute;
        bottom: 10px;
        right: 50px;
        border: 1px solid #000020;
        padding: 10px;
        display: none;
    }
</style>