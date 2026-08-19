var msg_rtl = true;		var msg_text = ''; var msg_type = 'error';

var current_ca_id = '';
var passiveInfo = { 'isPassiveMode' : false};

$(document).ready(function() { 	
	$.each($(".btn_order"), function(){
			if($(this).attr("onclick").indexOf("fnShowMessage")>-1) {
					$(this).trigger("click");
			} 
	});
});
var cart = new function() {
	this.del_cart = function(gbn, param_data){
		var isTrue = false;
		if(gbn == 'one') {
			isTrue = true;
			params = param_data;
		}
		else {
			var f = document.fcartlist;
			if(param_data=='cart_tab2') f = document.fcartlist2 ;

			if($("#"+param_data).find("[name=total_count]").val() <1){
				msg_text = replaceMessage('장바구니가 비어있습니다.',SIT_LNG);
				fn_msg_alert(msg_type, msg_text);	
				return;
			}
			else if ($("#"+param_data).find("input[name='chk[]']:checked", f).length < 1) {
				msg_text = replaceMessage('삭제할 상품을 하나 이상 선택하세요.',SIT_LNG);
				fn_msg_alert(msg_type, msg_text);	
				return;
			}
			else {
				isTrue = true;
				params = $("#"+param_data).find("input[name='chk[]']:checked", f).serialize();
			}
		}

		if (isTrue && confirm( replaceMessage('선택한 상품을 정말 삭제 하시겠습니까?',SIT_LNG))) { 
			$.ajax({
				 type: 'POST',
				 url: "/"+ SIT_LNG +"/cart/delete",
				 async:true ,                                    
				 data: params,
				 dataType: 'json',
				 success: function(json){
					 if(json.retCode == 200){
						 const evtId = (gbn == 'one') ? params.ca_id : '';
						 ga_cart_submit( evtId );
						 fnRecommendSDK('remove_from_cart', evtId);

						 if(gbn == 'one') {
							 $("#id_tr_" + params.ca_idx ).remove();
						 }
						 else{
							 $.each($("#"+param_data).find("input[name='chk[]']"), function(a,b){
								 if($(this).is(":checked")) $(this).parent().parent().parent().remove();
							 });
						 }

						 cart.cart_calculator('id_order_w');
						 cart.cart_calculator('id_order_r');
						 get_cart_count();
					 }
					msg_text = replaceMessage(json.msg,SIT_LNG);
					fn_msg_alert(msg_type, msg_text);	
				 },
				 error: function(request, status, error){ return false;	 },
				 complete: function(){		 }
			});
		}	
	}
	this.go_order = function(type, tab_id, id){
		var f = document.fcartlist;
		if(tab_id=='cart_tab2') f = document.fcartlist2 ;

		if($("#"+tab_id).find("[name=total_count]").val() <1){
			msg_text = replaceMessage('장바구니가 비어있습니다.',SIT_LNG);
			fn_msg_alert(msg_type, msg_text);	
			return;
		}
					
		if(type=="one"){
			if(Number($("input[name='chk[]'][value='"+id+"']").data('type').ca_price)==0){
				msg_text = replaceMessage('가격을 확인해 주세요.',SIT_LNG); fn_msg_alert(msg_type, msg_text); return false;
			}
			$("#"+ tab_id).find("[name=ca_idx]").val($("input[name='chk[]'][value='"+id+"']").data('type').ca_idx);
			$("#"+ tab_id).find("[name=ca_id]").val($("input[name='chk[]'][value='"+id+"']").data('type').ca_id);
			$("#"+ tab_id).find("[name=item]").val($("input[name='chk[]'][value='"+id+"']").data('type').ca_item);
		}
		else if(type=="sel"){
			if ($("#"+ tab_id).find("input[name='chk[]']:checked", f).length < 1) {
				msg_text = replaceMessage('주문할 상품을 하나 이상 선택하세요.',SIT_LNG);
				fn_msg_alert(msg_type, msg_text);	
				return;
			}
			var chk_zero_price = 0;
			$.each($("#"+ tab_id).find("input[name='chk[]'][type=checkbox]"),function(){
				if($(this).is(":checked")){
					if(Number($(this).data("type").ca_price)==0){
						chk_zero_price++;
					}
				}				
			});

			if(chk_zero_price > 0){
				msg_text = replaceMessage('가격을 확인해 주세요.',SIT_LNG);	fn_msg_alert(msg_type, msg_text);	return;
			}
			var i = 0;
			var tmpArr = new Array();
			$.each($("#"+ tab_id).find("input[name='chk[]'][type=checkbox]"),function(){
				if($(this).is(":checked")){
					if($(this).data("type2").cpn_id != "" && $(this).data("type2").cpn_id != undefined){
						tmpArr[i] = $(this).data("type2").cpn_id;
						i++;
					}
				}
			});
			
			if(tmpArr.length > 1){
				var tmpA;
				var tmpB;
				for(i = 1; i < tmpArr.length; i++){
					for(j = 0; j < i; j++){
						tmpA = tmpArr[i];
						tmpB = tmpArr[j];
						if(tmpA == tmpB){
							msg_text = replaceMessage('동일한 쿠폰 값이 있습니다.\n쿠폰번호 : ',SIT_LNG) + tmpB;
							fn_msg_alert(msg_type, msg_text);	
							return false;
							break
						 }
					}
				}					
			}
		}
		else if(type=="all"){
			var msg = replaceMessage('장바구니에 있는 모든 상품(총 total_count건)을 전체 주문합니다.\n계속 진행하시겠습니까?',SIT_LNG).replace(/total_count/g, $("#"+tab_id).find("[name=total_count]").val()) ;
			if(confirm( msg )){
			}else{
				return;
			}
		}else{
			if ($("#"+ tab_id).find("input[name='chk[]']:checked", f).length < 1) {
				msg_text = replaceMessage('주문할 상품을 하나 이상 선택하세요.',SIT_LNG);
				fn_msg_alert(msg_type, msg_text);	
				return;
			}
		}
		$("#"+tab_id).find("[name=type]").val(type);
		if(type=="sel"){
			if(tab_id == 'id_order_r') {
				$("#id_order_w").find("input[name='chk[]']").prop("checked",false);
			}
			else if(tab_id == 'id_order_w') {
				$("#id_order_r").find("input[name='chk[]']").prop("checked",false);
			}
		}

		var URL = "/"+ SIT_LNG +"/cart/able_check/ajax";
		$.ajax({
			url: URL,
			type: 'POST',
			data:'',
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8', 
			dataType: 'json',
			success: function (result) {
				if (result.order_able=='N'){
					var msg = (result.msg) ? result.msg : '주문이 불가합니다.';
					alert(msg); return;
				}
				else {
					f.action =  "/"+ SIT_LNG +"/order/step1_2";
					f.submit();
				}
			},
			error: function(request, status, error){
				console.log(request, status, error);
				return false;
			},
			complete: function(){
			}
		});
	}
	/*
		Function : orderDetailView() - 장바구니 - 레드메이커스의 경우 상세 레이어 제공
		Param : ca_id - 장바구니 아이디
	*/
	this.orderDetailView = function(ca_id){
		if(!ca_id){
		}else{
			$.ajax({
				   type: 'POST',
				   url: "/"+ SIT_LNG +"/cart/view",
				   async:true ,                                    
				   data: {ca_id:ca_id },
				   dataType: 'json',
				   success: function(json){
					   if(json.retCode == 200){
						   var obj = $.parseJSON(json.result['ca_option']);
						   execCartDetail(obj.STNMTMP_OPTION);
					   }else{
						   alert( replaceMessage('잠시후 이용하시기 바랍니다.',SIT_LNG) );
					   }
				   },
				   error: function(request, status, error){
					   return false;
				   },
				   complete: function(){

				   }
			});
		}
	}
	/*
		Function : cart_calculator() - 체크박스 선택에 따른 결제예정금액 산정
	*/
	this.cart_calculator = function(id){
		var cart_price = 0;
		var cart_price_vat = 0;
		var cart_price_total = 0;
		
		$.each($("#"+ id).find("input[name='chk[]'][type=checkbox]"),function(){
			if($(this).is(":checked")){
				cart_price+= Number($(this).data("type").ca_price);
				cart_price_vat	+= Number($(this).data("type").ca_price_vat);
				cart_price_total		+= Number($(this).data("type").ca_price) + Number($(this).data("type").ca_price_vat);
			}				
		});

		$("#"+id+"_cart_price").text($.number(cart_price) ); 
		$("#"+id+"_cart_price_vat").text($.number(cart_price_vat) ); 
		$("#"+id+"_cart_price_total").text($.number(cart_price_total) ); 
	}
	/*
		Function : sel_print() -
	*/
	this.sel_print = function(type, id){
		var f = document.fcartlist;
		if(id=='cart_tab2') f = document.fcartlist2 ;

		if($("#"+id).find("[name=total_count]").val() <1){
			msg_text = replaceMessage('장바구니가 비어있습니다.',SIT_LNG);
			fn_msg_alert(msg_type, msg_text);	
			return;
		}

		if(type=="sel"){
			if ($("#"+ id).find("input[name='chk[]']:checked", f).length < 1) {
				msg_text = replaceMessage('상품을 하나 이상 선택하세요.',SIT_LNG);
				fn_msg_alert(msg_type, msg_text);	
				return;
			}else{
				var tmp = new Array();
				$.each($("#"+id).find("input[name='chk[]'][type=checkbox]"), function(a,b) {
					if($(this).is(":checked")) { tmp.push( $(this).val() ); }
				});
				var params = tmp.join(',');

				var gsWin = window.open('about:blank','print','left=10, top=10, width=950, height=1130, scrollbars=yes');
				document.fcartprint.ca_idx.value = params;
				document.fcartprint.action = "/"+ SIT_LNG +"/cart/cart_print";
				document.fcartprint.target ="print";
				document.fcartprint.method ="post";
				document.fcartprint.submit();
			}
		}
	}
	this.reEditing = function(div){
		var obj = $(div).data('type');
		var projectId = obj.project_id;

		$("#edicusProjectID").val(projectId);
		$("#edicusToken").val(obj.token);
		$("#current_ca_id").val(obj.ca_id);
		
		if(obj.editor_type=="KOI"){
			if( !_init_limit() ){ return false; };

			const config	= {
				userId : $("#edicusUserID").val(),
				accessToken :	initData.access_token[ $(div).data('type').access_token ],
				sandboxMode : false
			}
			const Editor =	new	RedEditorSDK(config);	

			Editor.on('close', function(event){
				cart.set_cart_status('','end');
				$("body").css("overflow","");
				$('#editorWrapper').removeClass('active'); 
				window.location.reload(true);
			});

			Editor.on('save', function(d){
				if(passiveInfo.isPassiveMode){
					passiveInfo.totalPageCount 	= d.info.docInfo.totalPageCount;
					passiveInfo.isOrderAble 	= d.info.isOrderAble;
					passiveInfo.shortOfMessage 	= d.info.message;
				}
				if(d.action == "save-doc-report"){
					$("#edicusInfo").val(JSON.stringify(d.info));
					if(passiveInfo.isPassiveMode){
						cart.editorUpdate('KOI');
					}
					else{
						cart.editorUpdate('KOI');
					}
				}
				window.location.reload(true);
			});

			var mtrl_cod = '';
			var initPage = 0;
			if($(div).data('type2')){
					initPage = $(div).data('type2').number3;
					minPage = $(div).data('type2').minPage;
					maxPage = $(div).data('type2').maxPage;
					mtrl_cod = $(div).data('type').mtrl_cod;
			}

			if(!projectId){
				msg_text = replaceMessage('프로젝트아이디 오류입니다.',SIT_LNG);  fn_msg_alert(msg_type, msg_text);	return false;
			}
			if(!cart.set_cart_status(obj.ca_id, 'step1')) {
				msg_text = replaceMessage('잠시후 이용해 주세요',SIT_LNG); fn_msg_alert(msg_type, msg_text);	return false;
			}
			var lockGroupPageCount = false;
			if($.inArray(obj.pdt_cod, ['TPSTNME','TPTKDFT','TPSTPKG','GSPNBAL','GSPNDFT','GSBLGLF' ]) !=-1) { lockGroupPageCount = true; }

			const info_pdt_cod= (obj.easy_pdt_cod!='') ? obj.easy_pdt_cod : obj.pdt_cod;
			Editor.getProductInfo(info_pdt_cod).then(function(d){ 
				if(d.useFullyFunctionalUI){
					passiveInfo.isPassiveMode = true;
				}

				if(['TPSTNME','TPCAPTW','PHPLEDT','GSBLGLF','TPTKDFT'].includes(obj.pdt_cod)) passiveInfo.isPassiveMode = false;

				if(passiveInfo.isPassiveMode){
					$('#editorPreview').empty();
					$("body").css("overflow","hidden");
					$('#editorWrapper').addClass('active');						

					var editorConfig = {
							selector	: "#editorPreview",
							productCode	:  obj.pdt_cod
					};
					var openOption = {
						projectId		: $("#edicusProjectID").val(),
						clone			: false,
						uiLocale		: SIT_LNG, 
						autoSave		: 5,
						lockGroupPageCount : lockGroupPageCount
					};

					Editor.openFullyFunctionalUI(editorConfig, openOption);						
				}
				else{
					var openOptionPCS = new Object();
					var _mtrlCode = (mtrl_cod != undefined && mtrl_cod.length==8) ? mtrl_cod : '';
					var _exceptDisableElements = new Array(); 

					if(initPage>0) maxPage = initPage;					
					if($.inArray(obj.pdt_cod, ['PHBKBKS','PHBKSMP','PHBKPRM','PHBKPTP','PHBKMYB']) !=-1) openOptionPCS	= { initPageCount : Number(initPage),maxPage : Number(maxPage),minPage : Number(initPage)}
					if($.inArray(obj.pdt_cod, ['PHPTEDT','PHPTSHP','PHPTBKG','PHPTDFT' ]) !=-1) openOptionPCS	= {maxPage : Number(maxPage), minPage : Number(minPage)};
					if($.inArray(obj.pdt_cod, ['MEPKDFT','GSSMSTP']) !=-1) openOptionPCS.disableMasterColorPicker = true  ; //색상 picker off
					if($.inArray(obj.pdt_cod, ['FBCLTSH']) !=-1)		openOptionPCS.disableSelection = true ;  //가로/세로 toggle off
					if($.inArray(obj.pdt_cod, ['STTPMSK']) !=-1) 	openOptionPCS.disableTapeOptions = true ;
					if($.inArray(obj.pdt_cod, ['PHPRFRM','GSPNJEL','GSPNJLY','GSCACMR','GSPNBAL','GSTTPAP','PHSTPAN','GSPNDFT','GSFGMIN','STPADNM','STPADDY','STPADPN','PHMGDFT','PVCAPRM','GSMRLTH','GSKYHOT','TPSTNME','TPCAPTW','PHFRDIA','GSACPAN','GSNTPVC']) !=-1
						|| $.inArray(obj.pdt_cod.substr(0,2), ['PR', 'FS','BT','ST','BC','TP']) !=-1 || obj.ORD_MENU_GB=='OMG_ESY') {	openOptionPCS.disableAllOption = true ;		_exceptDisableElements.push('.get-button-div');	 }

					if(obj.pdt_cod=="TPHPFLM" && !['RXICR175'].includes( mtrl_cod ) )	openOptionPCS.unableLayers = "White";
					if(_mtrlCode || _exceptDisableElements) 	openOptionPCS.pluginCustomData = { mtrlCode : _mtrlCode, exceptDisableElements : _exceptDisableElements};

					// 2025-11-05 전체 적용
					openOptionPCS.disableAllOption = true ;		_exceptDisableElements.push('.get-button-div');


					Editor.setUserId($("#edicusUserID").val());
					$('#editorPreview').empty();
					$("body").css("overflow","hidden");
					$('#editorWrapper').addClass('active');

					var editorConfig = {
									selector      : "#editorPreview",
									projectId          :  projectId,
									locale	: SIT_LNG,
								}
					Editor.openProject(editorConfig, openOptionPCS);
				}
			});
		}
		else if(obj.editor_type=='RPEditor') { 
			rpeditor_open_init(projectId, 'cart');
		}
	}
	this.editorUpdate = function(div){		
		if($("#current_ca_id").val() && ($("#edicusInfo").val() || $("#RPEditorData").val()) ){
			$("#overlay, #PleaseWait").show();
			$.ajax({
					type: 'POST',
					url: "/"+ SIT_LNG +"/cart/update",
					async:false ,                                    
					data: {ca_id:$("#current_ca_id").val(),  edicusInfo: $("#edicusInfo").val(),  RPEditorData: $("#RPEditorData").val() },
					dataType: 'json',
					success: function(json){ 
						if(json.retCode == 200){
							cart.set_cart_status('','end');							
					   }
						 alert(json.msg);
						 location.href="/"+ SIT_LNG +"/cart";
					},
					error: function(request, status, error){
						return false;
					},
					complete: function(){ 
					}
			});
		}
	}
	this.update_qty = function(div){ 
		var obj = $(div).data('type');
		var number1 = Number($("#number1_"+obj.ca_idx).val());
		if( obj.ca_id != '' && (number1 > 0 && number1 != Number(obj.old_number1))  ){
			var msg = replaceMessage('인쇄수량[ 현재수량: old_number1 -- 변경수량: number1 ]을 변경하시겠습니까?',SIT_LNG).replace(/old_number1/g,Number(obj.old_number1)).replace(/number1/g,number1) ;
			if( msg ){
			$("#overlay").show();
			$("#PleaseWait").show();
				$.ajax({
				   type: 'POST',
				   url: "/"+ SIT_LNG +"/cart/update_qty",
				   async:true ,                                    
				   data: {ca_idx:obj.ca_idx, ca_id:obj.ca_id,  number1: number1 },
				   dataType: 'json',
				   success: function(json){
					   if(json.retCode == 200){
							alert( replaceMessage('수량을 변경했습니다.',SIT_LNG) );
					   }else{
						   alert(json.msg);
					   }
				   },
				   error: function(request, status, error){
						alert( replaceMessage('잠시후 이용하시기 바랍니다.',SIT_LNG) );
				   },
				   complete: function(){ 
						window.location.reload(true);
						return false;
				   }
				});
			}
		}
		else{
				msg_text = replaceMessage('수량을 확인해 주세요',SIT_LNG);
				fn_msg_alert(msg_type, msg_text);	
				return false;
		}
	}
	this.set_cart_status = function(ca_id, gbn) {
		if(ca_id != '') current_ca_id = ca_id;
		var rtl = false;
		var msg1 = (SIT_LNG=='en') ? 'No Order' : '주문 불가';
		var msg2 = (SIT_LNG=='en') ? 'Editor is updating.' : 'Editor 업데이트 중입니다.';
		var _html= '<a href="javascript:void(0);" class="btn_order" onclick="javascript:fnShowMessage(\''+current_ca_id+'\');" style=" color:#0fa8b5;">'+msg1+'<div id="isOrderAbleMessage_bc0d4116b0337de673a66f3d754c3d05" style="font-weight: 300; color: rgb(239, 67, 35); position: absolute; border: 1px solid rgb(204, 204, 204); background-color: rgb(255, 255, 255); padding: 5px; z-index: 1;">'+msg2+'</div></a>';
		
		if(current_ca_id) {
				$.ajax({
				   type: 'POST',
				   url: "/"+ SIT_LNG +"/cart/koi_status_update",
				   async:false ,                                    
				   data: {ca_id:current_ca_id, gbn: gbn},
				   dataType: 'json',
				   success: function(json){
					   if(json.retCode == 200){
							 $("[name='chk[]'][value="+current_ca_id+"]").prop("checked", false).attr("disabled", true);
							 $("[name='chk[]'][value="+current_ca_id+"]").parent().parent().parent().find('.individual_order').parent().parent().html(_html);
							 rtl = true;
					   }
				   },
				   error: function(request, status, error){
						alert( replaceMessage('잠시후 이용하시기 바랍니다.',SIT_LNG) );
				   },
				   complete: function(){ 
						return false;
				   }
				});
		}
		return rtl;
	}
}
function _init_limit(){	
	var isInappBroswer = ["KAKAOTALK", "NAVER", "inapp"].find( broswerVender => navigator.userAgent.includes(broswerVender));      
	var rtl = true;
	if (isInappBroswer){
		msg_text = replaceMessage( isInappBroswer + " 브라우저는 에디터 사용이 원활하지 않을 수 있습니다. 크롬(Chrome) 브라우저 사용을 권장드립니다.",SIT_LNG);
		fn_msg_alert(msg_type, msg_text);	
		rtl= false;
	}

	return rtl;
}
/* layer popup : S */
function closeCartDetail() {
	$("#cart_detail_layer").hide();
	$("#overlay").hide();
}

function execCartDetail(stnmtmp_option) {
	$("#cart_detail_layer").show();
	initCartDetailLayerPosition();
	
	$("#detail_item").children().remove();
	var html_str = "";
	var cart_price = 0; 

	for (var i in stnmtmp_option) {
		var tmpl_idx = stnmtmp_option[i]['tmpl_idx'];
		var tmpl_nme = stnmtmp_option[i]['tmpl_nme'];
		var paper = stnmtmp_option[i]['paper'];
		var paper_nme = stnmtmp_option[i]['paper_nme'];
		var number1 = stnmtmp_option[i]['number1'];
		var BASIC_TMPL_PRICE = stnmtmp_option[i]['BASIC_TMPL_PRICE']; 
		var no_name_yn = stnmtmp_option[i]['no_name_yn']; 
		var subject = stnmtmp_option[i]['subject']; 
		var COT_DFT = stnmtmp_option[i]['COT_DFT']; 
		var print_names = stnmtmp_option[i]['print_names'];
		var print_words1 = stnmtmp_option[i]['print_words1'];
		var print_words2 = stnmtmp_option[i]['print_words2'];

		cart_price += Number(BASIC_TMPL_PRICE);

		html_str = "<tr>";
		html_str += "<td>";
		html_str += parseInt(i)+1;
		html_str += "</td>";
		html_str += "<td style='text-align:left;'>";
		html_str += tmpl_nme ;

		if(subject != ""){html_str += " [제목 : " + subject + "] " ;}

		html_str += "<br> 옵션 : "; 
		html_str +=  paper_nme;

		html_str += "<br> 후가공 : ";
		if(COT_DFT=="TCMAS"){
			html_str += " 무광코팅단면 " ;
		}else{
			html_str += " 유광코팅단면 " ;
		}

		html_str += "<br> 문구-이름:";
		if(no_name_yn=="Y"){
			html_str += " (무지) " ;
		}else{
			html_str += print_names[0] ;
		}

		if(print_words1[0] != undefined && print_words1[0] != "" ){ html_str += "/  문구1-1:" + print_words1[0] ;}
		if(print_words2[0] != undefined && print_words2[0] != "" ){ html_str += "/  문구1-2:" + print_words2[0] ;}

		if(print_names[1] != undefined && print_names[1] != "" ){  html_str += " ||  문구-이름2:" + print_names[1] ;}
		if(print_words1[1] != undefined && print_words1[1] != "" ){ html_str += "/  문구2-1:" + print_words1[1] ;}
		if(print_words2[1] != undefined && print_words2[1] != "" ){ html_str += "/  문구2-2:" + print_words2[1] ;}

		html_str += "</td>";
		html_str += "<td>";
		html_str += $.number(number1) + " 장"  ;
		html_str += "</td>";
		html_str += "<td>";
		html_str += $.number(BASIC_TMPL_PRICE) + " 원" ;
		html_str += "</td>";
		html_str += "</tr>";

		$("#detail_item").append(html_str);
	}

	$("#detail_cart_price").text($.number(cart_price));
	$("#detail_cart_price_vat").text($.number(cart_price * 0.1));
	$("#detail_cart_total_price").text($.number(cart_price + cart_price * 0.1));
}
function initCartDetailLayerPosition(){
	var width = 950; 
	var height = 700; 
	var borderWidth = 2; 
	
	$("#overlay").show();

	$("#cart_detail_layer").css("width",width+'px');
	$("#cart_detail_layer").css("height",height+'px');
	$("#cart_detail_layer").css("border",borderWidth+'px solid');

	$("#cart_detail_layer").css("left",(((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px');
	$("#cart_detail_layer").css("top",(((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px');
}
function ga_cart_submit(ca_id)
{
	let __items = new Array();
	if(ca_id!='') {
			const __id = $("input[name='chk[]'][value='"+ca_id+"']").data('type2').product;
			const __item_name = $("input[name='chk[]'][value='"+ca_id+"']").data('type2').product_nm;
			const __item_category = "";
			const __price = Number($("input[name='chk[]'][value='"+ca_id+"']").data('type2').price) / Number($("input[name='chk[]'][value='"+ca_id+"']").data('type2').qty);
			const __quantity = $("input[name='chk[]'][value='"+ca_id+"']").data('type2').qty;

			const tmp = {
					item_id: __id,
					item_name: __item_name,
					currency: "KRW",
					item_brand: "redprinting",
					item_category: __item_category,
					price: __price,
					quantity: __quantity
			};
			__items.push(tmp);
	}
	else {
		$.each($("input[name='chk[]']:checked"),function(){
			const __id = $("input[name='chk[]'][value='"+this.value+"']").data('type2').product;
			const __item_name = $("input[name='chk[]'][value='"+this.value+"']").data('type2').product_nm;
			const __item_category = "";
			const __price = Number($("input[name='chk[]'][value='"+this.value+"']").data('type2').price) / Number($("input[name='chk[]'][value='"+this.value+"']").data('type2').qty);
			const __quantity = $("input[name='chk[]'][value='"+this.value+"']").data('type2').qty;

			const tmp = {
					item_id: __id,
					item_name: __item_name,
					currency: "KRW",
					item_brand: "redprinting",
					item_category: __item_category,
					price: __price,
					quantity: __quantity
			};
			__items.push(tmp);
		});
	}

	dataLayer.push({ ecommerce: null });  
	dataLayer.push({
		event: "remove_from_cart",
		ecommerce: {
			items: __items
		}
	});
}
function ga_cart_submit(ca_id)
{
	// 1. 대상을 먼저 결정 (특정 ID 혹은 체크된 항목들)
	const $targets = ca_id 
			? $(`input[name='chk[]'][value='${ca_id}']`) 
			: $("input[name='chk[]']:checked");

	// 2. map을 이용해 데이터 추출
	const items = $targets.map((_, el) => {
			const data = $(el).data('type2');
			const qty = Number(data.qty) || 1; // 0으로 나누기 방지

			return {
					item_id: data.product,
					item_name: data.product_nm,
					currency: "KRW",
					item_brand: "redprinting",
					item_category: "",
					price: Number(data.price) / qty,
					quantity: qty
			};
	}).get();

	// 3. dataLayer 전송
	window.dataLayer = window.dataLayer || [];
	dataLayer.push({ ecommerce: null });
	dataLayer.push({
			event: "remove_from_cart",
			ecommerce: { items }
	});
}
function fnQty(gbn, ca_idx)
{
	if(ca_idx){
		var number1 = Number($("#number1_"+ca_idx).val());
		var qty = number1;
		if(gbn=='up'){
			qty++;
		}
		else{
			qty--;
		}
		if(number1<1){
			qty = 1;				
		}
		$("#number1_"+ca_idx).val(qty);
	}
}
function fnShowMessage(ca_idx)
{	
	if(ca_idx){
		if($("#isOrderAbleMessage_"+ca_idx).css('display') == 'none')
			$("#isOrderAbleMessage_"+ca_idx).show();
		else
			$("#isOrderAbleMessage_"+ca_idx).hide();
	}
	else{
		$("[id^='isOrderAbleMessage_']").hide();
	}
}
function fnRecommendSDK(trackGbn, ca_id) {
	if(typeof RecommendSDK=='object') {
		const targets = ca_id 
				? $(`input[name='chk[]'][value='${ca_id}']`) 
				: $("input[name='chk[]']:checked");

		const __items = targets.map((_, el) => {
				const data = $(el).data('type2');
				const isQtyNeeded = (trackGbn=='view_cart') ? true : false; // 여기에 실제 조건(예: data.qty > 0 등)을 넣으세요.

				return {
						sku: data.product,
						...(isQtyNeeded && { quantity: data.qty })
				};
		}).get();

		RecommendSDK.trackEvent(trackGbn, {
			items: __items
		});
		console.log({RecommendSDK : trackGbn, item: __items});
	}
	return;
}
jQuery(document).ready(function($) {
	fnRecommendSDK("view_cart", "");
});