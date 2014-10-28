<%@ page language="java" trimDirectiveWhitespaces="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
    function checkGiftData() {
        $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/giftcode/ajax.html',
            data: 'uid=hahm',
            error: function (xhr, ajaxOptions, thrownError) {
            },
            success: function (data) {
            	if (data != '') {
                    $('#gift_code_value').html(data);
                    $('#giftModal').reveal({
                    	dismissmodalclass: 'modal_close'
                        });
                }
            }
        });
    }
    
    $(function () {
        setInterval(function () {
            return checkGiftData();
        }, 1000);
    })
</script>
<div id="giftModal" class="reveal-modal">
	<div class="srv_row">
		<label class="lbl_moi">Thông báo</label> Chúc mừng bạn đã được nhận một mã dự thưởng: <strong><span style="font-size: 24px;" id="gift_code_value"></span></strong>. 
		<br/>Bạn có cơ hội trúng thưởng trong chương trình quy số may mắn của 1Pay.
	</div>
	<div>
	<img alt="" src="<%=request.getContextPath()%>/images/samsung_galaxy_s3.jpg" border="0" width="500px"/>
	</div>
	<div>
	<input type="button" name="cancel" value="Đóng" class="btn_greensmall modal_close" />
	</div>
</div>