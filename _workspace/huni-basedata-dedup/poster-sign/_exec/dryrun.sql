-- T1 포스터사인/실사 면적격자 transpose 교정 — DRY-RUN (BEGIN ... ROLLBACK)
-- ★교정 방법 = 권위 면적매트릭스 verbatim 재적재 (blind swap 아님).
--   각 라이브 격자행을 권위 정답 좌표 (siz_width=가로, siz_height=세로)로만 교정.
--   DIRECT 193행(14 breaker 포함)은 이미 권위와 일치 → swap 대상에서 제외(무변경·회귀 0).
--   SWAP 491행: 라이브 (w,h)가 권위에 (h,w)로 존재(가격 동일) → comp_price_id 기반 정밀 교정.
--   genuine-missing 2행: banner 900x5000 권위값 INSERT.
-- 권위=인쇄상품가격표 "포스터사인" [가로(열)×세로(행)] (price-poster-sign-l1.csv 687셀).
-- 단가값(unit_price) verbatim 불변 — siz_width/siz_height 좌표만 교정.
-- 멱등: id 기반 교정이라 재실행 시 이미 정답=권위 DIRECT → 추가 변경 0.
-- 이 스크립트는 ROLLBACK 종결 (실 적용 아님). [[dryrun-vs-fix-script-commit-lesson]] 종결자 ROLLBACK 확인.

BEGIN;

-- ── 사전 상태: 권위 위배(width>1200) 행수 = transpose 잔재 ──
SELECT 'BEFORE width>1200 (transpose 잔재)' AS chk, count(*)
FROM t_prc_component_prices
WHERE comp_cd IN (
  'COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
  'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
  'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
  'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT')
  AND siz_width > 1200;

-- ════════════════ SWAP UPDATE (491행·권위 정답 좌표 교정) ════════════════
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21063;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=5000 WHERE comp_price_id=21065;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21066;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21072;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21073;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21074;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21077;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21079;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21080;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21081;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21083;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21084;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21087;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21092;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2200 WHERE comp_price_id=21094;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21097;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21098;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21099;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1000 WHERE comp_price_id=21100;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21101;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21102;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21103;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2800 WHERE comp_price_id=21105;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21106;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1600 WHERE comp_price_id=21108;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21109;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21112;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21113;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21115;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21116;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21118;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3500 WHERE comp_price_id=21119;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21121;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21123;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21124;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21126;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21127;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21128;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21129;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21131;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21132;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2000 WHERE comp_price_id=21133;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21134;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21137;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21138;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21140;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21141;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21142;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21143;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21145;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21147;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21148;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21151;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21153;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21154;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21155;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21156;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21158;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21162;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21163;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21165;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21166;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21167;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=4000 WHERE comp_price_id=21168;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21170;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21171;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21173;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21176;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21179;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21181;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21182;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21184;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21186;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=3000 WHERE comp_price_id=21187;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21188;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21189;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21190;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21191;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21192;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21194;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21196;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21198;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21201;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21202;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21204;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21205;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21206;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21207;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1800 WHERE comp_price_id=21209;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21210;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21215;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21217;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2400 WHERE comp_price_id=21218;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21221;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21223;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21224;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21225;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21226;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21227;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21230;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21231;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21232;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21233;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21235;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21236;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21237;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21238;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21239;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=600 WHERE comp_price_id=21240;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21242;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21244;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21245;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21247;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21248;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21250;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21251;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2600 WHERE comp_price_id=21253;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21254;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21255;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21262;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21264;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21265;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=4500 WHERE comp_price_id=21266;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1400 WHERE comp_price_id=21267;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21268;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21269;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21270;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21271;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21273;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21275;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21276;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21279;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1200 WHERE comp_price_id=21280;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21281;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21282;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21283;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21284;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21285;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21287;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21289;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21290;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21293;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21294;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21296;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21297;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21298;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21300;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21302;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21303;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21304;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21306;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21307;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21309;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=3500 WHERE comp_price_id=21310;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21311;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21312;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21313;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21314;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21316;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21317;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21318;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21319;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21323;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21324;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21326;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21330;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21331;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21333;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21335;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21336;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21337;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21339;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21343;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21345;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21346;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21349;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21350;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21351;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21353;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21354;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21355;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21356;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21357;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21359;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21360;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21362;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21363;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21364;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21366;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21368;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21370;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21371;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21372;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21374;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21375;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21376;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21377;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21378;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21379;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21381;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21382;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21384;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21385;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21386;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21389;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21390;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21391;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21395;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21396;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21397;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21398;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21400;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21401;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21402;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21404;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21405;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21406;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21407;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21409;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21411;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21413;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21414;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21415;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=800 WHERE comp_price_id=21417;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21418;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21419;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21422;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21425;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21426;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21427;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=4500 WHERE comp_price_id=21429;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21432;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21433;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21435;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21436;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21437;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21438;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21441;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21442;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21443;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21444;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21445;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21449;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21450;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1000 WHERE comp_price_id=21451;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21454;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21455;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21456;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21457;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21458;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21459;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21460;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21462;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21463;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21464;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21465;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21467;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21468;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21469;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21470;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21472;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21473;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21474;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21476;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21477;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21478;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21481;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21483;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21484;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21485;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21486;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21487;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21488;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21489;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21490;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21491;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21493;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21494;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21496;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2600 WHERE comp_price_id=21497;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21498;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21499;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21500;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21504;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21505;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21506;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21507;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21510;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21511;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21513;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21514;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21515;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21516;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21517;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21522;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21523;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21524;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21525;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21526;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21527;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21528;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21531;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21534;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21535;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21536;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21537;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21538;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21539;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1200 WHERE comp_price_id=21540;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21542;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21543;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21544;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21545;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21546;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21547;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21549;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21551;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21552;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21553;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21556;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21557;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21558;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21561;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21562;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21563;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=4000 WHERE comp_price_id=21564;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21565;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1400 WHERE comp_price_id=21568;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21570;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21571;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21574;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21576;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21579;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21580;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=21581;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21582;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21584;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21586;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=4500 WHERE comp_price_id=21587;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21588;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21590;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21591;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21592;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21593;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3500 WHERE comp_price_id=21594;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21596;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21599;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21603;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21608;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2400 WHERE comp_price_id=21609;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21610;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=3000 WHERE comp_price_id=21611;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2400 WHERE comp_price_id=21612;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21613;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1800 WHERE comp_price_id=21615;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21618;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1800 WHERE comp_price_id=21620;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21622;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21625;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=21628;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21629;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21631;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21633;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=21634;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21635;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21638;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21640;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=21641;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21642;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21643;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=3000 WHERE comp_price_id=21646;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=5000 WHERE comp_price_id=21647;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=21651;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21652;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21655;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2000 WHERE comp_price_id=21657;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21661;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21662;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2200 WHERE comp_price_id=21663;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21664;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=21665;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21666;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21667;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21671;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21672;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=21674;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=21678;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2800 WHERE comp_price_id=21681;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2200 WHERE comp_price_id=21682;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2600 WHERE comp_price_id=21684;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=21685;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21686;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1000 WHERE comp_price_id=21687;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1600 WHERE comp_price_id=21688;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=21690;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21692;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2000 WHERE comp_price_id=21693;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2000 WHERE comp_price_id=21694;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21695;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=21698;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=21699;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=21700;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=4000 WHERE comp_price_id=21701;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=1400 WHERE comp_price_id=21703;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=21704;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=21705;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21706;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21708;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21709;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=21711;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1400 WHERE comp_price_id=21713;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=21714;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=1600 WHERE comp_price_id=21719;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=21720;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1600 WHERE comp_price_id=21721;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=3000 WHERE comp_price_id=21723;
UPDATE t_prc_component_prices SET siz_width=600, siz_height=2400 WHERE comp_price_id=21724;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2200 WHERE comp_price_id=21725;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2800 WHERE comp_price_id=21726;
UPDATE t_prc_component_prices SET siz_width=800, siz_height=2600 WHERE comp_price_id=21727;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2800 WHERE comp_price_id=21729;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=900 WHERE comp_price_id=38142;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=900 WHERE comp_price_id=38143;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=1000 WHERE comp_price_id=38147;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=1000 WHERE comp_price_id=38148;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=1200 WHERE comp_price_id=38151;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=1200 WHERE comp_price_id=38152;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1400 WHERE comp_price_id=38153;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1400 WHERE comp_price_id=38154;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1400 WHERE comp_price_id=38155;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=1400 WHERE comp_price_id=38156;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=1400 WHERE comp_price_id=38157;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1600 WHERE comp_price_id=38159;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1600 WHERE comp_price_id=38160;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1600 WHERE comp_price_id=38161;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=1600 WHERE comp_price_id=38162;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=1600 WHERE comp_price_id=38163;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=1800 WHERE comp_price_id=38164;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=1800 WHERE comp_price_id=38165;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=1800 WHERE comp_price_id=38166;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=1800 WHERE comp_price_id=38167;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=1800 WHERE comp_price_id=38168;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2000 WHERE comp_price_id=38169;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2000 WHERE comp_price_id=38170;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2000 WHERE comp_price_id=38171;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=2000 WHERE comp_price_id=38172;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=2000 WHERE comp_price_id=38173;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2200 WHERE comp_price_id=38174;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2200 WHERE comp_price_id=38175;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2200 WHERE comp_price_id=38176;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=2200 WHERE comp_price_id=38177;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=2200 WHERE comp_price_id=38178;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2400 WHERE comp_price_id=38179;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2400 WHERE comp_price_id=38180;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2400 WHERE comp_price_id=38181;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=2400 WHERE comp_price_id=38182;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=2400 WHERE comp_price_id=38183;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2600 WHERE comp_price_id=38184;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2600 WHERE comp_price_id=38185;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2600 WHERE comp_price_id=38186;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=2600 WHERE comp_price_id=38187;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=2600 WHERE comp_price_id=38188;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=2800 WHERE comp_price_id=38189;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=2800 WHERE comp_price_id=38190;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=2800 WHERE comp_price_id=38191;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=2800 WHERE comp_price_id=38192;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=2800 WHERE comp_price_id=38193;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=3000 WHERE comp_price_id=38194;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3000 WHERE comp_price_id=38195;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3000 WHERE comp_price_id=38196;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=3000 WHERE comp_price_id=38197;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=3000 WHERE comp_price_id=38198;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=3500 WHERE comp_price_id=38199;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=3500 WHERE comp_price_id=38200;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=3500 WHERE comp_price_id=38201;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=3500 WHERE comp_price_id=38202;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=3500 WHERE comp_price_id=38203;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=4000 WHERE comp_price_id=38204;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=4000 WHERE comp_price_id=38205;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=4000 WHERE comp_price_id=38206;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=4000 WHERE comp_price_id=38207;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=4000 WHERE comp_price_id=38208;
UPDATE t_prc_component_prices SET siz_width=900, siz_height=4500 WHERE comp_price_id=38209;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=4500 WHERE comp_price_id=38210;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=4500 WHERE comp_price_id=38211;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=4500 WHERE comp_price_id=38212;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=4500 WHERE comp_price_id=38213;
UPDATE t_prc_component_prices SET siz_width=1000, siz_height=5000 WHERE comp_price_id=38214;
UPDATE t_prc_component_prices SET siz_width=1200, siz_height=5000 WHERE comp_price_id=38215;
UPDATE t_prc_component_prices SET siz_width=1500, siz_height=5000 WHERE comp_price_id=38216;
UPDATE t_prc_component_prices SET siz_width=1750, siz_height=5000 WHERE comp_price_id=38217;

-- ════════════════ genuine-missing INSERT (banner 900x5000·2행) ════════════════
-- 권위: BANNER_NORMAL 900x5000=36000 · BANNER_MESH 900x5000=90000 (라이브 정/역 둘다 부재)
-- 멱등 가드: NOT EXISTS (이미 있으면 INSERT 안 함)
INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, min_qty, unit_price, siz_width, siz_height, reg_dt)
SELECT 40384,'COMP_POSTER_BANNER_NORMAL','2026-06-01',1,36000,900,5000,now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_POSTER_BANNER_NORMAL' AND siz_width=900 AND siz_height=5000);

INSERT INTO t_prc_component_prices (comp_price_id, comp_cd, apply_ymd, unit_price, siz_width, siz_height, reg_dt)
SELECT 40385,'COMP_POSTER_BANNER_MESH','2026-06-01',90000,900,5000,now()
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_component_prices
  WHERE comp_cd='COMP_POSTER_BANNER_MESH' AND siz_width=900 AND siz_height=5000);

-- ── 사후 검증 1: width>1200 = 0이어야 정상(전 셀 권위 정렬) ──
SELECT 'AFTER width>1200 (0이어야 정상)' AS chk, count(*)
FROM t_prc_component_prices
WHERE comp_cd IN (
  'COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
  'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
  'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
  'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT')
  AND siz_width > 1200;

-- ── 사후 검증 2: 14 breaker 무변경 확인 (H1800 셀이 그대로 600x1800인가) ──
SELECT 'BREAKER H1800 무변경(=11 또는 12)' AS chk, count(*)
FROM t_prc_component_prices
WHERE comp_cd IN (
  'COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
  'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
  'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
  'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT')
  AND siz_width=600 AND siz_height=1800;

-- ── 사후 검증 3: 핵심 셀 = 권위 좌표로 이동했나 ──
SELECT 'CHECK 600x1400=20000(ARTPRINT)' AS chk, siz_width::int, siz_height::int, unit_price::int
FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND siz_width=600 AND siz_height=1400;

SELECT 'CHECK 1200x3000=72000(ARTPRINT)' AS chk, siz_width::int, siz_height::int, unit_price::int
FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_ARTPRINT_PHOTO' AND siz_width=1200 AND siz_height=3000;

SELECT 'CHECK banner 900x5000 INSERT됨' AS chk, comp_cd, siz_width::int, siz_height::int, unit_price::int
FROM t_prc_component_prices WHERE comp_cd IN ('COMP_POSTER_BANNER_NORMAL','COMP_POSTER_BANNER_MESH') AND siz_width=900 AND siz_height=5000 ORDER BY comp_cd;

-- ── 멱등 재실행 검증: 다시 width>1200 행 = 0 (재-swap 후보 없음) ──
SELECT 'IDEMPOTENT recheck width>1200' AS chk, count(*)
FROM t_prc_component_prices
WHERE comp_cd LIKE 'COMP_POSTER%' AND siz_width>1200
  AND comp_cd IN ('COMP_POSTER_ARTPRINT_PHOTO','COMP_POSTER_ARTPAPER_MATTE','COMP_POSTER_WATERPROOF_PET',
  'COMP_POSTER_ADH_WATERPROOF_PVC','COMP_POSTER_ADH_CLEAR_PVC','COMP_POSTER_ARTFABRIC_GRAPHIC',
  'COMP_POSTER_LINEN_FABRIC','COMP_POSTER_CANVAS_FABRIC','COMP_POSTER_LEATHER_ARTPRINT',
  'COMP_POSTER_TYVEK_PRINT','COMP_POSTER_MESH_PRINT');

ROLLBACK;  -- ★DRY-RUN 종결자. 실 적용은 apply.sql(COMMIT).
