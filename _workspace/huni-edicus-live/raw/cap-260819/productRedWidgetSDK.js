var SIT_LNG = "ko";
if($("#SIT_LNG").val() != "" && $("#SIT_LNG").val() != undefined) SIT_LNG = $("#SIT_LNG").val();

var msg_rtl = true;		var msg_text = ''; var msg_type = 'error'; var msg_auto_close= true;

var org_mainFlsh_html = "";
var org_editorConfig = '';
var org_saveData = editorData = '';

let RedWidget, KoiEditor, vRPEditor
const isDebug=false;

var productOrder = new function() {
	this.order_validate = function(orderType, e) {
		fnPreOrder(orderType, e) ; // 로그인 폼에서 사용: 공용
	}
	this.login_check = function(){
		var self = productOrder;
		var rtl = false;
		$.ajax({
			type: 'POST',
			url: "/"+ SIT_LNG +"/member/login/login_check",
			async:false ,                                    
			data: { },
			dataType: 'json',
			success: function(json){ 
				if(json.retCode == 200)	rtl = true;
				else rtl = false;
			},
			error: function(request, status, error){
				rtl = false;
			},
			complete: function(){
			}
		});
		if(guest_check_click) rtl = true;
		return rtl;
	}
	this.login_layer = function(orderType, orderForm) {
		if($("#IN_USR").val()=='Y'){
			productOrder.login_layer_a(orderType, orderForm);
		}
		else{
			productOrder.login_layer_b(orderType, orderForm);
		}
	}
	this.login_layer_a = function(orderType, orderForm) {
		if(orderForm == "" || orderForm == undefined) orderForm = "productOrder";

		$("#login_layer_modal").html("");
		$("#login_layer_modal").load("/" + SIT_LNG + "/member/login/login_form?order_type="+orderType+"&order_form="+orderForm+"",function(){
			$('#myLayerLogin').modal();
			$("#myLayerLogin > .modal-dialog.modal-sm.modal-alert").attr("style","width: 832px !important;");
			$("#myLayerLogin > .modal-dialog").css("height","unset");
		});
	}
	this.login_layer_b = function(orderType) {
		html  = '<div id="myLayerLogin" class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true" style="display: none;">';
		html += '	<div class="modal-dialog modal-sm modal-alert">';
		html += '			<div class="modal-content modal-alert-content">';
		html += '					<div class="modal-header" style="height:100%;">';
		html += '							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>';
		html += '							<h4 class="modal-title" id="mySmallModalLabel">' + replaceMessage('로그인',SIT_LNG) + '</h4>';
		html += '					</div>';
		html += '					<div class="modal-body">'; 
		html += '						<div class="login_box" style="padding: 0;">'; 
		html += '							<fieldset>'; 
		html += '							<label for="layer_mb_id" class="label" style="float: left; margin: 0px;">ID</label>'; 
		html += '							<input id="layer_mb_id" name="layer_mb_id" type="text" value="" maxlength="20" placeholder="' + replaceMessage('ID를 입력해 주세요',SIT_LNG) + '" class="input_text placeholder" onkeypress="productOrder.enterKey(\''+orderType+'\',event)" autofocus="" style="float:right; width:70%;">'; 
		html += '							<div id="errorUsername" class="error_validate"></div>'; 
		html += '							<label for="layer_mb_password" class="label" style="float: left; margin: 0px;">' + replaceMessage('비밀번호',SIT_LNG) + '</label>'; 
		html += '							<input id="layer_mb_password" name="layer_mb_password" type="password" maxlength="20" placeholder="' + replaceMessage('비밀번호를 입력하세요.',SIT_LNG) + '" class="input_text placeholder" onkeypress="productOrder.enterKey(\''+orderType+'\',event)" style="float:right;width:70%;">'; 
		html += '							<div id="errorPassword" class="error_validate"></div>'; 
		html += '							<button id="layer_login" onclick="productOrder.layer_login(\''+orderType+'\');" class="btn_login">LOGIN</button>'; 
		html += '							<div class="login_bottom">'; 
		html += '							<div class="link_wrap"><a href="/'+SIT_LNG+'/member/forget_idpwd/id">' + replaceMessage('아이디 찾기',SIT_LNG) + '</a><span>|</span><a href="/'+SIT_LNG+'/member/forget_idpwd/password">' + replaceMessage('비밀번호 찾기',SIT_LNG) + '</a></div><a href="/'+SIT_LNG+'/member/join" class="btn_sign">' + replaceMessage('회원이 아니신가요?',SIT_LNG) + ' <span> ' + replaceMessage('회원가입',SIT_LNG) + '</span></a>'; 
		html += '							 </div>'; 
		html += '							</fieldset>'; 
		html += '						</div>'; 
		html += '					</div>';
		html += '			</div>';
		html += '	</div>';
		html += '</div>';		
		if($(".order-page").length>0){
			$(".order-page").parent().parent().append(html);
			$('#myLayerLogin').modal();
		}
		else{
			$(".page_order").parent().parent().append(html);
			$('#myLayerLogin').modal();
		}
		$('.modal-backdrop').attr("style","z-index:301");
	}
	this.layer_login = function(orderType){
		var self = productOrder;
		var mb_id = $.trim($("#layer_mb_id").val());
		var mb_password = $.trim($("#layer_mb_password").val());

		if(mb_id==""){
			alert(replaceMessage("아이디를 입력하세요.",SIT_LNG));		return false;
		}
		if(mb_password==""){
			alert(replaceMessage("암호를 입력하세요",SIT_LNG));		return false;
		}

		if(mb_id != "" && mb_password != "" ){
			$("#layer_login").attr("disabled",true);
			$.ajax({
				type: 'POST',
				url: "/"+ SIT_LNG +"/member/login/layer_login",
				async: false ,                                    
				data: { mb_id: mb_id, mb_password: mb_password },
				dataType: 'json',
				success: function(json){
					if(json.retCode == 200){
						if(typeof RecommendSDK=='object') {
							const _trigger = (orderType=='order') ? 'buy_now_click' : 'add_to_cart';
						  RecommendSDK.trackEvent('login_popup', { trigger: _trigger });
							RecommendSDK.identify({ userId: mb_id });
						}

						if(json.retMsgSns != '') alert( json.retMsgSns );

						if(json.mall_cust_yn=="Y"){
							alert(replaceMessage("분양몰 업체로 로그인하셨습니다. 정확한 할인율 적용을 위해 다시한번 주문해주시기 바랍니다.",SIT_LNG));
							window.location.reload(true);	return false;
						}else if(json.discount_cust_yn=="Y"){
							alert(replaceMessage("할인 업체로 로그인하셨습니다. 정확한 할인율 적용을 위해 다시한번 주문해주시기 바랍니다.",SIT_LNG));
							window.location.reload(true);	return false;
						}else if(orderType=="edicus"){
							window.location.reload(true);	return false;
						}else{
							fnPreOrder(orderType); 
						}
					}
					else{
						alert(json.retMsg);	return false;
					}						
				},
				error: function(request, status, error){
					return false;
				},
				complete: function(){						
					$("#layer_login").attr("disabled",false);
				}
			});
		}
	}
	this.enterKey = function(orderType, e){
		if(e.keyCode == 13){
			productOrder.layer_login(orderType);
		}else{
			e.keyCode == 0;
			return false;
		}
	}
	this.loading = function(div){
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		var left = ( $(window).scrollLeft() + ($(window).width() - $("#PleaseWait").width()) / 2 );
		if(left<0) left = 0; 

		if(div=="show"){
			$("#overlay").css({'width':maskWidth,'height':maskHeight});
			$("#PleaseWait").css({"left":left}); 
			$("#overlay, #PleaseWait").show();
		}else{
			$("#overlay, #PleaseWait").hide();
		}
	}
}

jQuery(document).ready(function($){
	fnInitSdk();
	fnRightFloating();

	//왼쪽 이미지 마우스 오버시..
	$(".class_left_img").mouseover(function(){
		if(!editorData.saveData){
			$(".mainFlsh").html( '<img src="'+$(this).attr("src")+'"/>' );
		}
	});	
	//left banner - swiper
	var swiper = new Swiper(".underThum-mySwiper", {
		loop: true,
		autoplay: {
			delay: 2500,
			disableOnInteraction: false,
		},
		pagination: {
			el: ".swiper-pagination",
			dynamicBullets: true,
		},
	});
});

function sdkInit(opt) {
	if(isDebug) console.log({fnInit : opt});
	const p = {productInfo : RedWidget.getProductBaseInfo() };
	
	if(p.productInfo?.product_option.option.order_yn=='N') {
		if(initProductData.pdt_cod=='PRCAMOS') {
			msg_auto_close = false; msg_text = (SIT_LNG=='en') ? 'Mosaic Card launches at 9:00 AM on August 3rd.' : '모자이크 카드는 8월 3일 오전 9시 오픈됩니다.';  fn_msg_alert(msg_type, msg_text, msg_auto_close);	
			limit_html= (SIT_LNG=='en') ? '<em class="salestop-text">Mosaic Card launches at 9:00 AM on August 3rd.</em>' : '<em class="salestop-text">모자이크 카드는 8월 3일 오전 9시 오픈됩니다.</em>';		
			$("#detail_wrap").append(limit_html);
		}
		else {
			msg_auto_close = false; msg_text = replaceMessage('주문이 불가합니다. 이용에 불편을 드려 죄송합니다.',SIT_LNG);  fn_msg_alert(msg_type, msg_text, msg_auto_close);	
			const limit_html= (SIT_LNG=='en') ? '<em class="salestop-text">Temporarily Unavailable</em>' : '<em class="salestop-text">일시적으로 주문이 불가합니다</em>';		
			$("#detail_wrap").append(limit_html);
		}
	}
	if(p.productInfo?.product_option.option.order_yn=='Y'
		&& p.productInfo?.product_option.option.price_table_yn=='Y') $("#id_btn_price_table").show();
}
function fnInitSdk() {
	const pdt_cod = initProductData.pdt_cod;
	const ptt_cod = initProductData.ptt_cod;
	const ClientKey = 'red-pc';
	const widgetSDK = new window.RedWidgetSDK(ClientKey);  

	const config = {
		target : '#redWidgetSdk',
		pdtCode : pdt_cod,
		pttCode : ptt_cod,
		locale : SIT_LNG,
		member : {
			mb_id : initProductData.member?.mb_id,
			mb_cust_cod : initProductData.member?.mb_cust_cod,
			bsn_yn : initProductData.member?.mb_bsn_yn,
			pot_yn : initProductData.member?.is_pot_create,
		},
	};
	const callbacks = {
		onMounted:  (opt) => { sdkInit(opt); },
		onOptionChange: (opt) => { sdkOptionChange(opt); },
		onInformMaterials: (opt) => { sdkInformMaterials(opt); },
		onOpenEditor: (opt) => { sdkOpenEditor(opt); },
		onCreatePot: (opt) => { sdkCreatePot(opt); },
		onReset: (ResetFactors) => { sdkEditorCheck(ResetFactors); },
		onInformGuide:  (opt) => { sdkGuide(opt); },
		//onInformPrintGuide:  (opt) => { sdkPrintAreaGuide(opt); },
		//onPriceChange: (priceSummary) => { fnChangePrice(priceSummary); },
	};
	RedWidget = widgetSDK.init(config, callbacks);
	if(isDebug) console.log({widgetSDK : widgetSDK, widget : {config: config, callbacks: callbacks}});
}
function sdkOptionChange(opt) {
	if(typeof $.number !== 'function') { $.number = function(n){ return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }; }
	if(isDebug) console.log({sdkOptionChange: opt});

	if(['COMMON'].includes(opt.type) && opt.summary) { 
		let price = opt.summary.price.value;
		let vat = opt.summary.vat.value;
		let totalPrice = opt.summary.totalPrice.value;
		let unitPrice = opt.summary.unitPrice.value;

		// 일반 할인업체,직원할인 등
		if(opt.data.priceCalc.result.result_sum.PRICE_MALL>0 
			&& ( opt.data.priceCalc.result.result_sum.PRICE_MALL<opt.data.priceCalc.result.result_sum.PRICE || opt.data.priceCalc.result.result_sum.PRICE_MALL<opt.data.priceCalc.result.result_sum.ORG_PRICE) ) {
			price = opt.data.priceCalc.result.result_sum.ORG_PRICE;
			vat = opt.data.priceCalc.result.result_sum.ORG_PRICE_VAT; 
			const salePrice = totalPrice - (price + vat);

			$("#id_price_sale").text( $.number(salePrice) ).parent().removeClass('hide');
		}
		else if(opt.data.priceCalc.result.result_sum.PRICE < opt.data.priceCalc.result.result_sum.ORG_PRICE && opt.data.priceCalc.result.result_sum.PRICE < opt.data.priceCalc.result.result_sum.PRICE_MALL) {
			// 행사 할인 
			totalPrice = opt.data.priceCalc.result.result_sum.PRICE + opt.data.priceCalc.result.result_sum.PRICE_VAT;
			unitPrice = totalPrice / (opt.data.quantityInfo.ordCnt * opt.data.quantityInfo.prnCnt);
			price = opt.data.priceCalc.result.result_sum.ORG_PRICE;
			vat = opt.data.priceCalc.result.result_sum.ORG_PRICE_VAT; 
			const salePrice = totalPrice - (price + vat);

			$("#id_price_sale").text( $.number(salePrice) ).parent().removeClass('hide');
		}

		if(opt.summary.boxQty) { //책자류
			$("#RForderQty").find("b").text($.number(opt.summary.orderQty.value)).parent().find("h5").text(opt.summary.orderQty.label);
			$("#RFweight").find("b").text(opt.summary.weight.value).parent().find("h5").text(opt.summary.weight.label); 
			$("#RFboxQty").find("b").text(opt.summary.boxQty.value).parent().find("h5").text(opt.summary.boxQty.label); 
			$("#RFprice").find("b").text($.number(price)).parent().find("h5").text(opt.summary.price.label); 
			$("#RFvat").find("b").text($.number(vat)).parent().find("h5").text(opt.summary.vat.label); 
			$("#RFunitPrice").find("b").text($.number(unitPrice)).parent().find("h5").text(opt.summary.unitPrice.label);
			$("#RFtotalPrice").find("b").text($.number(totalPrice)).parent().find("h5").text(opt.summary.totalPrice.label); 
			$("#RFshippingPrice1, #RFshippingPrice2").find("b").text($.number(opt.summary.shipping.value)).parent().find("h5").text(opt.summary.shipping.label);
		}
		else {
			if(opt.summary.method) $("#RFmethod").find("b").text(opt.summary.method.value).parent().find("h5").text(opt.summary.method.label);
			else  $("#RFmethod").parent().hide();
			if(opt.summary.cutSize && opt.data.dosuInfo.COD!='SID_X') $("#RFcutSize").parent().show().find("b").text(opt.summary.cutSize.value).parent().find("h5").text(opt.summary.cutSize.label);
			else  $("#RFcutSize").parent().hide();
			if(opt.summary.workSize && opt.data.dosuInfo.COD!='SID_X') $("#RFworkSize").parent().show().find("b").text(opt.summary.workSize.value).parent().find("h5").text(opt.summary.workSize.label);
			else  $("#RFworkSize").parent().hide();
			if(opt.summary.designQty) $("#RFdesignQty").find("b").text($.number(opt.summary.designQty.value)).parent().find("h5").text(opt.summary.designQty.label);
			else  $("#RFdesignQty").parent().hide();
			if(opt.summary.orderQty) $("#RForderQty").find("b").text($.number(opt.summary.orderQty.value)).parent().find("h5").text(opt.summary.orderQty.label);
			else  $("#RForderQty").parent().hide();
			if(opt.summary.unitPrice) $("#RFunitPrice").find("b").text($.number(unitPrice)).parent().find("h5").text(opt.summary.unitPrice.label);
			if(opt.summary.totalPrice) $("#RFtotalPrice").find("b").text($.number(totalPrice)).parent().find("h5").text(opt.summary.totalPrice.label);
		}
	
		const html_price_total = ( (SIT_LNG=='en') ? '<span class="price-num-quaper">' + $.number(unitPrice) + ' Won/unit</span> ' : '<span class="price-num-quaper">개당 ' + $.number(unitPrice) + '원 </span> ' ) + $.number(totalPrice);	

		$("#id_price").text($.number(price)).parent().find("h5").text(opt.summary.price.label); 
		$("#id_price_vat").text($.number(vat)).parent().find("h5").text(opt.summary.vat.label); 
		$("#id_price_total_html").html( html_price_total );

		$(".floating-box").show();
	}
	else if(['ACC'].includes(opt.type)) { 
		let price = opt.data.priceCalc.result.result_sum.PRICE;
		let vat = opt.data.priceCalc.result.result_sum.PRICE_VAT;
		let totalPrice = price + vat;

		if(opt.data.priceCalc.result.result_sum.PRICE_MALL>0 && opt.data.priceCalc.result.result_sum.PRICE_MALL<opt.data.priceCalc.result.result_sum.PRICE) {
			const price_mall = opt.data.priceCalc.result.result_sum.PRICE_MALL;
			const price_mall_vat = opt.data.priceCalc.result.result_sum.PRICE_MALL_VAT;
			totalPrice = price_mall + price_mall_vat;

			const salePrice = (price + vat) -  totalPrice;

			$("#id_price_sale").text('-' + $.number(salePrice) ).parent().removeClass('hide');
		}

		const html_price_total = $.number(totalPrice);	

		$("#id_price").text($.number(price)); 
		$("#id_price_vat").text($.number(vat)); 
		$("#id_price_total_html").html( html_price_total );
	}
} 
function sdkInformMaterials(mtrls){
	if(isDebug) console.log({sdkInformMaterials: mtrls});

	if(mtrls) {
		let pdt_cod = mtrls[0].PDT_COD;
		let _gbn2  = (['BN','AH','AI','PO'].includes(pdt_cod.substr(0,2))) ? 'real' : 'digital'; 

		$("#order_able_paper>li").remove();
		$.each(mtrls, function(index, obj) {
			var pdt_link = '';
				pdt_link += '<li>';
				pdt_link += '		<a data-toggle="modal" data-target="#modal-paper-info1" onclick="fn_order_able(\''+obj.PTT_COD+'\',\''+obj.PTT_NME+'\',\''+obj.PTT_SUB+'\',\''+obj.PTT_INFO+'\',\''+_gbn2+'\')" >';
				pdt_link += '			<img src="'+obj.IMG_URL_DEFAULT+'" alt="'+obj.PTT_NME+'"></a>';
				pdt_link += '			<div class="paper-detail">';
				pdt_link += '				<p class="paper-name">'+obj.PTT_NME+'</p>';
				pdt_link += '				<p class="paper-thick">'+obj.PTT_SUB+'</p>';
				pdt_link += '				<p class="paper-text">'+obj.PTT_INFO.replace(/\./gi,".<br>")+'</p>';
				pdt_link += '			</div>';
				pdt_link += '	</li>';

				$("#order_able_paper").append(pdt_link);
		});

		if(pdt_cod.substr(0,2) == "ST") $("#msg_sticker").show();
		else  $("#msg_sticker").hide();

		$("#modal-papers").modal();
	}
}
function sdkOpenEditor(e){
	if(isDebug) console.log({sdkOpenEditor: e});

	const gbn = 'vue';
	const p = {productInfo : RedWidget.getProductBaseInfo() };
	const c = {customOrderData : RedWidget.getOrderData() };		

	if(e.type=='KOI') fnKoiEditor(gbn, e, p, c);	
	else if (e.type=='RP') fnRpEditor(gbn, e, p, c);
}
function fnKoiEditorInit(p, c) {		
	var config	= {
		//initialStageUrl : 'https://edicus-stage.firebaseapp.com', //주의 INT만
		userId : p.productInfo?.member_info.edicusUserID,
		accessToken :	p.productInfo?.product_option.option.koiAccessToken,
		sandboxMode : false // 운영 false, 개발 true
	}
	KoiEditor =	new	RedEditorSDK(config);	

	KoiEditor.on('close', function(d){
		fnSetEditingThumbnail(p);

		let type = 'KOI';
		fnSetEditingInfo(type, p, c);

		$("body").css("overflow","");
		$('#editorWrapper').removeClass('active');
		$(".header-manu").show();
	});
	KoiEditor.on('save', function(d){
		editorData = {	saveData : d.info, editorConfig : org_editorConfig	}; 
		if(isDebug) console.log({KoiEditor : 'save', editorData : editorData});
	});
	KoiEditor.on("customTabSelectionChange", async (data)=> {
		const selection =KoiEditor.getCustomTabSelectInfo(data.info);				
		const res = await RedWidget.getKOIEditorTabData(selection);
		if(res.type=='PRICE') KoiEditor.setPrice(res.data.toLocaleString());
		if(isDebug) console.log({customTabSelectionChange : {param : selection, res : res}});
	});
	KoiEditor.on("docReport", (data)=> {
		let selection =KoiEditor.getCustomTabSelectInfo(data.info.docInfo.prodVarInfo.prodVarMap);
		KoiEditor.saveThenClose({removeOutterItems : true});
	});
	KoiEditor.on('load', function(data){
	});
}
async function fnKoiEditor(gbn, e, p, c) {
	if(isDebug) console.log({fnKoiEditor: gbn, e : e});
	if(typeof(KoiEditor)=='undefined') {	fnKoiEditorInit(p, c);		}

	if(!e.config) {
		alert('에디터-config를 확인하세요');		return false;
		msg_rtl = false;
	}
	else {
		msg_rtl = true;
	}

	if(msg_rtl) {
		if(gbn!=='pot_create') {
			$('#editorPreview').empty();
			$("body").css("overflow","hidden");
			$('#editorWrapper').addClass('active');
			$(".header-manu").hide();
		}

		e.config.selector = "#editorPreview";
		e.config.accessToken = p.productInfo?.product_option.option.koiAccessToken; // 주의

		if(e.config.projectId) {
			if(p.productInfo.product_option.option.pdt_cod.substr(0,2)=='CL') {
				e.option = editorData.editorConfig.optionPCS; // 의류 옵션 재사용
			}
			KoiEditor.openProject(e.config, e.option);
		}
		else{
			org_editorConfig = {config : e.config, optionPCS: e.option};
			if(gbn=='pot_create') { 
				editorData = {saveData : '', editorConfig : org_editorConfig}	; 
			}
			else {
				if(typeof RecommendSDK=='object') {
					RecommendSDK.trackEvent('editing', { sku: p.productInfo.product_option.option.pdt_cod });
				}
				const org_editorConfig2 = {...org_editorConfig};
				if(isDebug) console.log('fnKoiEditor createProject >>>>>>', {org_editorConfig : org_editorConfig}, c.customOrderData);
				KoiEditor.createProject(e.config, e.option);
			}
		}
	}
}
function fnRpEditorInit(p, c) {
	if(typeof(vRPEditor)=='undefined' && p.productInfo?.member_info.edicusUserID) {
		const config = {
			accessToken: 'accessToken',
			userId: p.productInfo?.member_info.edicusUserID,
			sandboxMode: false, //  true : stage , false : production , locall : local
			email: 'tinyman@naver.com',
			initType: 'edit',
		};
		vRPEditor =	new	RPEditorSDK(config);	

		vRPEditor.on('all', (data) => {
		});
		vRPEditor.on('create', (data) => {
		});
		vRPEditor.on('close', (data) => {
			$("body").css("overflow","");
			$('#RPeditorWrapper').removeClass('active');
			$(".header-manu").show();
		});
		vRPEditor.on('save-close', (data) => {
			editorData = {	saveData : data, editorConfig : org_editorConfig	}; 
			if(isDebug) console.log({vRPEditor : 'save', editorData : editorData});

			// 1. validate
			//if( !fnEditCloseValidate() ){  	return;		}
			// 2. 썸네일..
			fnSetEditingThumbnail(p);
			// 4. 에디터정보반영
			let type = 'RP';
			fnSetEditingInfo(type, p, c);

			// 3. 화면
			$("body").css("overflow","");
			$('#RPeditorWrapper').removeClass('active');
			$(".header-manu").show();
		});
		vRPEditor.on('error-close', (data) => {
			$("body").css("overflow","");
			$('#RPeditorWrapper').removeClass('active');
			$(".header-manu").show();
		});
	}
}
async function fnRpEditor(gbn, e, p, c) {
	if(p.productInfo.product_option?.option.useRPEditor=='N') return false;
	if(typeof(vRPEditor)=='undefined') {	fnRpEditorInit(p, c); }

	e.config.selector = "#RPeditorPreview";
	e.config.access_key = p.productInfo.product_option.option.rpAccessToken.token;
	e.config.lang = SIT_LNG.toUpperCase();
	e.config.user_id = p.productInfo.member_info.mb_id;

	let editorConfig = e.config;
	let editorOptions = {};

	if(e.config.initType=='open') {
		editorConfig = editorData.editorConfig; //초기화.
		editorConfig.project_id = e.config.project_id; 
		editorConfig.initType = e.config.initType; 

		const msg = (SIT_LNG=='en')?'Would you like to re-edit as there are already edited contents?':'이미 편집한 내용이 있습니다. 재편집하시겠습니까?';
		if (!confirm(msg) ){
			return false;
		}
	}
	org_editorConfig = editorConfig; // Koi 와 형식 다르다.

	if (editorConfig.initType==='open') {
		$("body").css("overflow","hidden");$('#RPeditorWrapper').addClass('active');
		activateEditor = vRPEditor.openProject(editorConfig, editorOptions);
	} 
	else {
		if(gbn=='pot_create') { 
			editorData = {saveData : '', editorConfig : org_editorConfig}	; 
		}
		else {
			if(typeof RecommendSDK=='object') {
				RecommendSDK.trackEvent('editing', { sku: p.productInfo.product_option.option.pdt_cod });
			}
			$("body").css("overflow","hidden");$('#RPeditorWrapper').addClass('active');
			activateEditor = vRPEditor.createProject(editorConfig, editorOptions);
		}
	}
	if(isDebug) console.log('initType >>' , editorConfig.initType, {config : org_editorConfig});
}
function fnSetEditingThumbnail(p) {
	let thumList = [];
	if(p.productInfo.product_option?.option.useKoiEditor=='Y') thumList = editorData.saveData?.docInfo.tnUrlList;
	else if(p.productInfo.product_option?.option.useRPEditor=='Y') {
		$.each(editorData.saveData?.thumb_list, function(a,b) {
			thumList.push(b.url);
		});
	}

	if(thumList?.length>0) {
		var _html = '';
		var nowdate = new Date();
		var string_connet = (thumList[0].indexOf('?')>-1) ?  '&' : '?';
		$.each(thumList, function(idx, thum) {
			if(org_mainFlsh_html == ''){ org_mainFlsh_html = $.trim($(".mainFlsh").html()); }		
			_html += '<li style="position: absolute; top: 0px; left: 0px; display: none; z-index: auto; opacity: 0; width: 618px; height: 618px;"><img src="'+thum + string_connet + nowdate.getTime()+'"/></li>';	
		});
		if(thumList.length==1) {
			_html += '<li><img src="'+thumList[0] + string_connet + nowdate.getTime()+'"/></li>';	
		}			
		$(".mainFlsh").html(_html);

		if(thumList.length>1 && typeof $.fn.cycle === 'function') {
			$(".mainFlsh").cycle({
				fx		: "fade",
				speed	: "slow",
				timeout	: 4000
			});
		} else {
			$(".mainFlsh li:first").css({display:'block', opacity:1});
		}
	}
} 
function fnSetEditingInfo(_type, p, c) {
	if(editorData.saveData) {
		let param ={};
		if(_type=='KOI') {
			param = {
				type: _type,
				projectID: editorData.saveData?.projectID,
				docInfo: editorData.saveData.docInfo,
			};
			if(editorData.saveData?.docInfo.prodVarInfo) {
				let selection =KoiEditor.getCustomTabSelectInfo(editorData.saveData.docInfo.prodVarInfo.prodVarMap);
				param.customTabSelectedInfo = selection;
			} 
		}
		else if(_type=='RP') {
			param = {
				type: _type,
				_id: editorData.saveData?._id,
				fileInfo : { 
					bundle_count : editorData.saveData.bundle_count, 
					size_name_info : editorData.saveData.size_name_info},
			};
		}
		const tmp = RedWidget.setEditorData(param);
		if(isDebug) console.log({'fnSetEditingInfo >>>': param}, tmp);
	}		
}
function sdkEditorCheck(e) {
	const p = {productInfo : RedWidget.getProductBaseInfo() };

	if(isDebug) console.log({step:'fnEditorCheck', e:e});
	if( !['BCSPHIG'].includes(p.productInfo.product_option.option.pdt_cod) && e=='white') return; //2026-04-29 sdk에서 화이트 관련 이슈 발생.
	if(editorData!=='') {
		org_saveData = editorData = '';	
		if(org_mainFlsh_html!=='') $(".mainFlsh").html( org_mainFlsh_html );
		msg_text = replaceMessage('해당 옵션을 바꾸면 에디터를 통해 다시 변경된 정보로 편집을 해야 주문가능합니다.',SIT_LNG) + ' ' + replaceMessage('편집된 데이터를 초기화 합니다.',SIT_LNG);
		fn_msg_alert(msg_type, msg_text, msg_auto_close);	

		const tmp = RedWidget.setEditorData(null);
		if(isDebug) console.log({'sdkEditorCheck >>>': ''}, tmp);
	}
}
function sdkPrintAreaGuide() { 
	document.getElementById("detail_desc").scrollIntoView({behavior : 'smooth', block:'nearest'});
	setTimeout(()=> {
		window.scrollTo({top: document.querySelector('html').scrollTop-100 }); 
		if($("#answer01").length>0) 
			$("#answer01").parent().find('em').eq(0).trigger('click');
	}, 1500); 
}
function sdkGuide(e) { 
	const p = {productInfo : RedWidget.getProductBaseInfo() };
	let goUrl = '';
	if(e=='size' && p.productInfo.product_option.option.pdt_cod.substr(0,4)=='PRBK') goUrl = '/' + SIT_LNG + '/guide2/view/4/106' ;
	else if(e=='bookCover' && p.productInfo.product_option.option.pdt_cod.substr(0,4)=='PRBK') goUrl = '/' + SIT_LNG + '/guide2/view/4' ;
	else if(e=='SCO_DFT') goUrl = '/' + SIT_LNG + '/guide2/view/3/73' ;
	else if(e=='print') sdkPrintAreaGuide();

	if(goUrl) {
		window.open( goUrl );
	}
	if(isDebug) console.log({sdkGuide, e});
}
function sdkCreatePot(e){
	if(isDebug) console.log({sdkCreatePot: e});

	const orderType = 'pot_create';
	//if(typeof(e.customerOrderData.subMtrlInfo)!=='object') {
	if(e.editorData.editorConfig) {
		editorData = e.editorData;
		editorData.editorConfig.selector = '#editorPreview';
		if(editorData.editorOption?.customTabInfo?.data.material) {
			const mtrl_cd = e.customerOrderData.meterialInfo.MTRL_CD;
			editorData.editorOption.customTabInfo.data.material = [ editorData.editorOption.customTabInfo.data.material.find((ele)=>ele.MTRL_CD==mtrl_cd) ];
			editorData.editorOption.customTabInfo.data.postPCS = [ editorData.editorOption.customTabInfo.data.postPCS.find((ele)=>ele.MTRL_CD==mtrl_cd) ];
		}

		setTimeout(function(){ 
			fnPreOrder(orderType, e);
		}, 100);
	}
	else {
		fnPreOrder(orderType, e);
	}
}
function fnPreOrder(orderType, e) {
	const p = {productInfo : RedWidget.getProductBaseInfo() };
	const c = {customOrderData : RedWidget.getOrderData() };

	const pdt_cod = (p.productInfo.product_option.option.pdt_cod) ? p.productInfo.product_option.option.pdt_cod : p.productInfo.product_data.pdt_base_info[0].PDT_CD;
	const checkCanOrder = RedWidget.canOrder();

	$("#pot_tmp_cod").val(''); // 초기화
	 
	if(c.customOrderData.clothesSelectData!=undefined && c.customOrderData.clothesSelectData.sizeInfo?.length==0) {
		alert(replaceMessage("의류-사이즈정보 확인. 사이즈가 주문불가일 수 있습니다.",SIT_LNG));		return false;
	}

	//2026-06-04 임시
	var msg_rtl = true;		var msg_text = ''; var msg_type = 'error'; var msg_auto_close= true;
	if(msg_rtl && $("#chk_period_confirm").length>0){
		if( !$("#chk_period_confirm").is(":checked") ){
			msg_type = 'info'; msg_rtl = false; msg_text = replaceMessage("제작 기간 [확인했습니다]를 체크해주세요.",SIT_LNG);
		}
	}		
	if(msg_rtl && $("#chk_notice_confirm").length>0){
		if( !$("#chk_notice_confirm").is(":checked") ){
			msg_type = 'info'; msg_rtl = false; msg_text = replaceMessage("유의 사항 [확인했습니다]를 체크해주세요.",SIT_LNG);
		}
	}
	if( !msg_rtl ){ fn_msg_alert(msg_type, msg_text, msg_auto_close);	return false; }
	 
	if( !checkCanOrder.success && !['pot_create'].includes(orderType) ) {
			alert(replaceMessage(checkCanOrder.errorMessage, SIT_LNG));		return false;
	}
	if(!productOrder.login_check()){ 
		productOrder.login_layer( orderType ); 
	}
	else {
			$("#cart_btn, #order_btn").attr('disabled',true);
			$("#myLayerLogin").modal("hide");
			productOrder.loading('show');
			if($.inArray(orderType, ['cart','order','guest','pot_create'])===-1) {
				alert(replaceMessage("올바르지 않는 접근입니다.",SIT_LNG));		return false;
			}
			
			let _customerOrderData = c.customOrderData;
			if(typeof RecommendSDK=='object') {
				if(orderType=='cart') 
					RecommendSDK.trackEvent("add_to_cart", { sku: "" });
				else if(orderType=='order')
					RecommendSDK.trackEvent("purchase", { orderId: "", paymentMethod: "" });

				if(isDebug) console.log({RecommendSDK : orderType});
			}

			var params = JSON.stringify( {memberInfo : p.productInfo.member_info,  customerOrderData : _customerOrderData, editorData : editorData} );

			var submitUrl = "/"+ SIT_LNG +"/cart/ext_add";
			if(orderType == 'pot_create') submitUrl = "/"+ SIT_LNG +"/product_option/ext_set_pot_req_proc";
			
			$.ajax({
				url: submitUrl,
				type : 'POST',
				data : {formData : params, pdt_cod : pdt_cod},
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8', 
				dataType: 'json',
				success: function (data) {
					if (data.retCode==200){
						if(['order','guest'].includes(orderType)) {
							location.href= "/"+ SIT_LNG +"/order/step1_2/" + data.result.ca_id; return;
						}
						else if(orderType=='cart') {							
							$("#modal-shopCart").modal("show");	
							productOrder.loading('hide');
							get_cart_count();
							return;
						}
						else if(orderType == 'pot_create'){
							alert("정상적으로 생성했습니다.\n" + data.result.tmp_cod)
							console.log(data.result.tmp_cod);
							setTimeout(function(){ productOrder.loading('hide'); }, 1000);
						}
					}
					else{
						console.log(data.msg);
						alert(data.msg);							
						productOrder.loading('hide');
						return;
					}
					$("#cart_btn, #order_btn").attr('disabled',false);
				},
				error: function(request, status, error){
					$("#cart_btn, #order_btn").attr('disabled',false);
					rtl = false;
				},
				complete: function(){
					$("#cart_btn, #order_btn").attr('disabled',false);
				}
			}); 
	}
}
function fnCalcPriceTable() {
	productOrder.loading('show');

	const p = {productInfo : RedWidget.getProductBaseInfo() };
	const c = {customOrderData : RedWidget.getOrderData() };

	const pdt_cod = (p.productInfo.product_option.option.pdt_cod) ? p.productInfo.product_option.option.pdt_cod : p.productInfo.product_data.pdt_base_info[0].PDT_CD;
	const opt_data = c.customOrderData;

	const pcsInfo = [], pcsNme = [];
		opt_data.pcsInfo?.forEach((ele) => {
			ele.selectedOptions?.forEach((ele2) => {
				const _pcsData = {
					PCS_COD: ele2.PCS_CD,
					PCS_DTL_COD: ele2.PCS_DTL_CD,
					ATTB: ele2.ATTB ? ele2.ATTB : '',
					ATTB_2: ele2.ATTB_2 ? ele2.ATTB_2 : '',
					ATTB_3: ele2.ATTB_3 ? ele2.ATTB_3 : '',
					ESN_YN: ele.ESN_YN,
				};

				let isTrue = true; 
				if(isTrue) { 
					pcsInfo.push(_pcsData);				
					pcsNme.push(ele2.PCS_DTL_NM);
				}
			});
		});
	const ordCnt = (!['GSPNJLY','TPCLWAL','TPCLHOL','TPCLSTD','PRCLWAL','PRCLHOL','PRCLSTD','TPCLWLB','TPCLECO'].includes(pdt_cod)) ? 1 : opt_data.quantityInfo.ordCnt; // 2025-11-26 무조건 건수1로.. 연필등은 수정해야 한다.
	const dataJson = {
		"ORD_INFO": [
			{
				"CUST_COD": p.productInfo.member_info.mb_cust_cod ,
				"PDT_CD": pdt_cod ,
				"MTRL_CD": opt_data.meterialInfo.MTRL_CD ,
				"CUT_WDT": opt_data.sizeInfo.cutSize.width ,
				"CUT_HGH": opt_data.sizeInfo.cutSize.height ,
				"WRK_WDT": opt_data.sizeInfo.workSize.width ,
				"WRK_HGH": opt_data.sizeInfo.workSize.height ,
				"PRN_CNT": opt_data.quantityInfo.prnCnt ,
				"ORD_CNT": ordCnt ,
				"DOSU_COD": opt_data.dosuInfo.COD ,
				"PRN_CLR_CNT": opt_data.dosuInfo.PRN_CLR_CNT ,
			}
		],
		"PCS_INFO": pcsInfo,
		"price_gbn": p.productInfo.product_option.option.price_gbn,
	};
	const params = JSON.stringify( {dataJson : dataJson} );
	const URL = "/"+ SIT_LNG +"/product_price/get_calc_price_table";
	
	const optFix = ' | ';
	let cpt_option_name = '';
			if(opt_data.meterialInfo.MTRL_NM) cpt_option_name += ( (cpt_option_name) ? optFix : '' ) + opt_data.meterialInfo.MTRL_NM;
			if(opt_data.dosuInfo.COD_NME) cpt_option_name += ( (cpt_option_name) ? optFix : '' ) + opt_data.dosuInfo.COD_NME;
			if(opt_data.sizeInfo.cutSize.width) cpt_option_name += ( (cpt_option_name) ? optFix : '' ) + opt_data.sizeInfo.cutSize.width + 'X' + opt_data.sizeInfo.cutSize.height;
			if(pcsNme) cpt_option_name += ( (cpt_option_name) ? optFix : '' ) + pcsNme.join(' | ');

	$("#id_cpt_pdt_name").text( p.productInfo.product_option.option.pdt_nme );
	$("#id_cpt_option_name").text( cpt_option_name );

	$.ajax({
		url: URL,
		type : 'POST',
		data : {formData : params},
		contentType: 'application/x-www-form-urlencoded; charset=UTF-8', 
		dataType: 'json',
		success: function (data) {
			if (data.retCode==200){
				$("#id_price_data").html( data.result_html );
				$("#id_price_table").addClass('active');
			}
			else {
				alert( data.msg );
			}
		},
		error: function(request, status, error){
			rtl = false;
		},
		complete: function(){
			productOrder.loading('hide');
		}
	});
}
function fnEstimate() {
	const p = {productInfo : RedWidget.getProductBaseInfo() };
	const c = {customOrderData : RedWidget.getOrderData() };

	const pdt_cod = (p.productInfo.product_option.option.pdt_cod) ? p.productInfo.product_option.option.pdt_cod : p.productInfo.product_data.pdt_base_info[0].PDT_CD;
	const checkCanOrder = RedWidget.canOrder();

	if( !checkCanOrder.success ) {
		if(['GSSBSTP','GSSBMTL','GSSBACM','GSSBCAF','GSSBWED'].includes(pdt_cod)) {
			msg_text = replaceMessage('선택된 옵션이 없습니다. 주문할 옵션을 선택해주세요.',SIT_LNG);
			fn_msg_alert(msg_type, msg_text, msg_auto_close);	 return false;
		}
	}

	var gsWin = window.open('about:blank','print','left=10, top=10, width=950, height=1130, scrollbars=yes');
	var url = "/"+ SIT_LNG +"/product/estimate_print_vue";
	var newForm = $('<form></form>');
	newForm.attr("method", "post");
	newForm.attr("action", url);
	newForm.attr("target", "print");

	newForm.append($('<input/>', {type: 'hidden', name: 'productInfo', value: JSON.stringify(p) }));
	newForm.append($('<input/>', {type: 'hidden', name: 'customData', value: JSON.stringify(c) }));

	newForm.appendTo('body');
	document.charset = "euc-kr";
	newForm.submit();
}
function fnRightFloating() {
	$(".icon-padding").on("click", function() { $(".floating-box").hide();	});	
	window.addEventListener("scroll", function () {
		const container = document.querySelector(".has-floating-box");
		const floatingBox = document.querySelector(".floating-box");
		if(container!=null && floatingBox!=null) {			
			const rootEl = document.querySelector('.offset-book');
			const containerTop = container.getBoundingClientRect().top + window.pageYOffset;
			const rootElTop = rootEl.getBoundingClientRect().top + window.pageYOffset;
			const rootElBottom = rootEl.getBoundingClientRect().bottom + window.pageYOffset;
			const floatingBoxHeight = floatingBox.offsetHeight; // 플로팅 박스 높이
			let newTop = window.pageYOffset - containerTop + 100;
			let maxTop = rootElBottom - floatingBoxHeight - containerTop;
			if (newTop > maxTop) newTop = maxTop;
			if (window.pageYOffset >= containerTop - 100) floatingBox.style.top = `${newTop}px`;
			else	floatingBox.style.top = `0px`;
		}
	});
}
function cart_display(div) {
	window.location.reload(true);	return false;
}
