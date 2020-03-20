$(function () {
    function display(bool) {
        if (bool) {
            $("#container").fadeIn();
		} else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var data = event.data;
        if (data.type === "Hud") {
            if (data.display == true) {
                display(true)
            } else {
                display(false)
			}
			
			$("#Heading").val(data.PedHeading);
			if (data.TypeCoords === 0) {
				$("#input").val(data.PedA);
			} else if (data.TypeCoords === 1) {
				$("#input").val(data.PedB);
			} else if (data.TypeCoords === 2) {
				$("#input").val(data.PedC);
			}
		} 
		else if (data.type === "Notice") {
			$("#Notice").hide();
			
			if (data.NoticeType == "success") {
				$("#Notice").attr('class', 'alert-success');
			} else if (data.NoticeType == "error") {
				$("#Notice").attr('class', 'alert-error');
			} else if (data.NoticeType == "exit") {
				$("#Notice").attr('class', 'alert-exit');
			}
			// $("#Notice").html(data.NoticeMsg).show().delay(5000).fadeOut();
			$("#Notice").html(data.NoticeMsg).show();	
			
			window.setTimeout(function(){
				$("#Notice").fadeOut()
			},2000);
		}
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://getcoords/exit', JSON.stringify({
				exitmsg: "❌ 關閉視窗",
			}));
            return;
        } else if (data.which == 9) {
            $.post('http://getcoords/switch', JSON.stringify({
				msg: "🔁 座標格式切換",
			}));
            return;
        }
    };
	
    $("#close").click(function () {
		$.post('http://getcoords/exit', JSON.stringify({
			exitmsg: "❌ 關閉視窗",
		}));
		return;
    })

    $("#switch").click(function () {
		$.post("http://getcoords/switch", JSON.stringify({
			msg: '🔁 座標格式切換',
		}));
		return;
    })
})