/*
	License
	
	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software, to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish and distribute
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:
	
	This permission notice shall be included in all copies
	or substantial portions of the Software. Except as
	contained in this notice, the name(s) of the above
	copyright holders shall not be used in advertising
	or otherwise to promote the sale, use or other dealings
	in this Software without prior written authorization.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
*/

SendMode Input	;make it fast
CoordMode, ToolTip, Screen ;ToolTips are used to inform user and needs to be Screen relative
#SingleInstance force
#UseHook	;As Input is used it will be installed anyway
#MaxThreadsPerHotkey 1	;Hotkeys will be run only once (They will be run after relasing of the keys)
;#HotkeyModifierTimeout -1	;Not necessary because of Hook and SendInput 
#NoEnv	;Environment variables will not be checked
;#KeyHistory 15
;#SingleInstance
#InstallKeybdHook
;#HotkeyModifierTimeout 100
;Process, Priority, , High
StringTrimRight, SCRIPTNAME_VAR, A_ScriptName, 4 ;Name of Gui's
mwt_MaxWindows = 50 ;Maximal windows to hide (WINDOWHIDER)
mwt_StandardMenu = Y ;Use Standard Tray Menu, e.g. Pause Script
;SetWinDelay 100 ;Not Used
;SetKeyDelay -1

config = config.ini ;configuration file including all keywords, settings and macros
StringCaseSense, On ;will be turned off after Password was checked
eingabestarttooltip =  - ESC      = CANCEL`n- ALT+M = OPTIONS ;standard text of main gui when launching anything CAPSLOCK+TAB
outleertooltip := eingabestarttooltip ;needed to display more options and display standard text again

;Install hiedit for editing macros
FileInstall, HiEdit.dll, HiEdit.dll, 0
FileGetTime, filetime, A_ScriptName
FileGetTime, kwfiletime, KeyWords.hes
If (filetime != kwfiletime)
FileInstall, KeyWords.hes, KeyWords.hes, 1

;		HOTKEYs FOR CAPS/NUM/SCROLLLOCK


;Supported Hotkeys for CAPSLOCK, SCROLLLOCK and NUMLOCK
hotkeykeys = a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z.0.1.2.3.4.5.6.7.8.9
;Supported HOTKEYS for HOTKEY**
hotkeys = 01.02.03.04.05.06.07.08.09.0a.0b.0c.0d.0e.0f.0g.0h.0i.0j.0k.0l.0m.0n.0o.0p.0q.0r.0s.0t.0u.0v.0w.0x.0y.0z.10.12.13.14.15.16.17.18.19.1a.1b.1c.1d.1e.1f.1g.1h.1i.1j.1k.1l.1m.1n.1o.1p.1q.1r.1s.1t.1u.1v.1w.1x.1y.1z.20.21.23.24.25.26.27.28.29.2a.2b.2c.2d.2e.2f.2g.2h.2i.2j.2k.2l.2m.2n.2o.2p.2q.2r.2s.2t.2u.2v.2w.2x.2y.2z.30.31.32.34.35.36.37.38.39.3a.3b.3c.3d.3e.3f.3g.3h.3i.3j.3k.3l.3m.3n.3o.3p.3q.3r.3s.3t.3u.3v.3w.3x.3y.3z.40.41.42.43.45.46.47.48.49.4a.4b.4c.4d.4e.4f.4g.4h.4i.4j.4k.4l.4m.4n.4o.4p.4q.4r.4s.4t.4u.4v.4w.4x.4y.4z.50.51.52.53.54.56.57.58.59.5a.5b.5c.5d.5e.5f.5g.5h.5i.5j.5k.5l.5m.5n.5o.5p.5q.5r.5s.5t.5u.5v.5w.5x.5y.5z.60.61.62.63.64.65.67.68.69.6a.6b.6c.6d.6e.6f.6g.6h.6i.6j.6k.6l.6m.6n.6o.6p.6q.6r.6s.6t.6u.6v.6w.6x.6y.6z.70.71.72.73.74.75.76.78.79.7a.7b.7c.7d.7e.7f.7g.7h.7i.7j.7k.7l.7m.7n.7o.7p.7q.7r.7s.7t.7u.7v.7w.7x.7y.7z.80.81.82.83.84.85.86.87.89.8a.8b.8c.8d.8e.8f.8g.8h.8i.8j.8k.8l.8m.8n.8o.8p.8q.8r.8s.8t.8u.8v.8w.8x.8y.8z.90.91.92.93.94.95.96.97.98.9a.9b.9c.9d.9e.9f.9g.9h.9i.9j.9k.9l.9m.9n.9o.9p.9q.9r.9s.9t.9u.9v.9w.9x.9y.9z.a0.a1.a2.a3.a4.a5.a6.a7.a8.a9.ab.ac.ad.ae.af.ag.ah.ai.aj.ak.al.am.an.ao.ap.aq.ar.as.at.au.av.aw.ax.ay.az.b0.b1.b2.b3.b4.b5.b6.b7.b8.b9.ba.bc.bd.be.bf.bg.bh.bi.bj.bk.bl.bm.bn.bo.bp.bq.br.bs.bt.bu.bv.bw.bx.by.bz.c0.c1.c2.c3.c4.c5.c6.c7.c8.c9.ca.cb.cd.ce.cf.cg.ch.ci.cj.ck.cl.cm.cn.co.cp.cq.cr.cs.ct.cu.cv.cw.cx.cy.cz.d0.d1.d2.d3.d4.d5.d6.d7.d8.d9.da.db.dc.de.df.dg.dh.di.dj.dk.dl.dm.dn.do.dp.dq.dr.ds.dt.du.dv.dw.dx.dy.dz.e0.e1.e2.e3.e4.e5.e6.e7.e8.e9.ea.eb.ec.ed.ef.eg.eh.ei.ej.ek.el.em.en.eo.ep.eq.er.es.et.eu.ev.ew.ex.ey.ez.f0.f1.f2.f3.f4.f5.f6.f7.f8.f9.fa.fb.fc.fd.fe.fg.fh.fi.fj.fk.fl.fm.fn.fo.fp.fq.fr.fs.ft.fu.fv.fw.fx.fy.fz.g0.g1.g2.g3.g4.g5.g6.g7.g8.g9.ga.gb.gc.gd.ge.gf.gh.gi.gj.gk.gl.gm.gn.go.gp.gq.gr.gs.gt.gu.gv.gw.gx.gy.gz.h0.h1.h2.h3.h4.h5.h6.h7.h8.h9.ha.hb.hc.hd.he.hf.hg.hi.hj.hk.hl.hm.hn.ho.hp.hq.hr.hs.ht.hu.hv.hw.hx.hy.hz.i0.i1.i2.i3.i4.i5.i6.i7.i8.i9.ia.ib.ic.id.ie.if.ig.ih.ij.ik.il.im.in.io.ip.iq.ir.is.it.iu.iv.iw.ix.iy.iz.j0.j1.j2.j3.j4.j5.j6.j7.j8.j9.ja.jb.jc.jd.je.jf.jg.jh.ji.jk.jl.jm.jn.jo.jp.jq.jr.js.jt.ju.jv.jw.jx.jy.jz.k0.k1.k2.k3.k4.k5.k6.k7.k8.k9.ka.kb.kc.kd.ke.kf.kg.kh.ki.kj.kl.km.kn.ko.kp.kq.kr.ks.kt.ku.kv.kw.kx.ky.kz.l0.l1.l2.l3.l4.l5.l6.l7.l8.l9.la.lb.lc.ld.le.lf.lg.lh.li.lj.lk.lm.ln.lo.lp.lq.lr.ls.lt.lu.lv.lw.lx.ly.lz.m0.m1.m2.m3.m4.m5.m6.m7.m8.m9.ma.mb.mc.md.me.mf.mg.mh.mi.mj.mk.ml.mn.mo.mp.mq.mr.ms.mt.mu.mv.mw.mx.my.mz.n0.n1.n2.n3.n4.n5.n6.n7.n8.n9.na.nb.nc.nd.ne.nf.ng.nh.ni.nj.nk.nl.nm.no.np.nq.nr.ns.nt.nu.nv.nw.nx.ny.nz.o0.o1.o2.o3.o4.o5.o6.o7.o8.o9.oa.ob.oc.od.oe.of.og.oh.oi.oj.ok.ol.om.on.op.oq.or.os.ot.ou.ov.ow.ox.oy.oz.p0.p1.p2.p3.p4.p5.p6.p7.p8.p9.pa.pb.pc.pd.pe.pf.pg.ph.pi.pj.pk.pl.pm.pn.po.pq.pr.ps.pt.pu.pv.pw.px.py.pz.q0.q1.q2.q3.q4.q5.q6.q7.q8.q9.qa.qb.qc.qd.qe.qf.qg.qh.qi.qj.qk.ql.qm.qn.qo.qp.qr.qs.qt.qu.qv.qw.qx.qy.qz.r0.r1.r2.r3.r4.r5.r6.r7.r8.r9.ra.rb.rc.rd.re.rf.rg.rh.ri.rj.rk.rl.rm.rn.ro.rp.rq.rs.rt.ru.rv.rw.rx.ry.rz.s0.s1.s2.s3.s4.s5.s6.s7.s8.s9.sa.sb.sc.sd.se.sf.sg.sh.si.sj.sk.sl.sm.sn.so.sp.sq.sr.st.su.sv.sw.sx.sy.sz.t0.t1.t2.t3.t4.t5.t6.t7.t8.t9.ta.tb.tc.td.te.tf.tg.th.ti.tj.tk.tl.tm.tn.to.tp.tq.tr.ts.tu.tv.tw.tx.ty.tz.u0.u1.u2.u3.u4.u5.u6.u7.u8.u9.ua.ub.uc.ud.ue.uf.ug.uh.ui.uj.uk.ul.um.un.uo.up.uq.ur.us.ut.uv.uw.ux.uy.uz.v0.v1.v2.v3.v4.v5.v6.v7.v8.v9.va.vb.vc.vd.ve.vf.vg.vh.vi.vj.vk.vl.vm.vn.vo.vp.vq.vr.vs.vt.vu.vw.vx.vy.vz.w0.w1.w2.w3.w4.w5.w6.w7.w8.w9.wa.wb.wc.wd.we.wf.wg.wh.wi.wj.wk.wl.wm.wn.wo.wp.wq.wr.ws.wt.wu.wv.wx.wy.wz.x0.x1.x2.x3.x4.x5.x6.x7.x8.x9.xa.xb.xc.xd.xe.xf.xg.xh.xi.xj.xk.xl.xm.xn.xo.xp.xq.xr.xs.xt.xu.xv.xw.xy.xz.y0.y1.y2.y3.y4.y5.y6.y7.y8.y9.ya.yb.yc.yd.ye.yf.yg.yh.yi.yj.yk.yl.ym.yn.yo.yp.yq.yr.ys.yt.yu.yv.yw.yx.yz.z0.z1.z2.z3.z4.z5.z6.z7.z8.z9.za.zb.zc.zd.ze.zf.zg.zh.zi.zj.zk.zl.zm.zn.zo.zp.zq.zr.zs.zt.zu.zv.zw.zx.zy
;SUPPORTED NUMPAD HOTKEYS
numkeys = 01.02.03.04.05.06.07.08.09.10.12.13.14.15.16.17.18.19.20.21.23.24.25.26.27.28.29.30.31.32.34.35.36.37.38.39.40.41.42.43.45.46.47.48.49.50.51.52.53.54.56.57.58.59.60.61.62.63.64.65.67.68.69.70.71.72.73.74.75.76.78.79.80.81.82.83.84.85.86.87.89.90.91.92.93.94.95.96.97.98
StringSplit, hotkeykeys, hotkeykeys, ., . ;Stores each possible hotkey CAPS/SCROLL/NUMLOCK in Array to create them later
StringSplit, numkeys, numkeys, ., . ;Stores each possible hotkey for Numkeys only
StringSplit, hotkeys, hotkeys, ., . ;Stores each possible hotkey for HOTKEY**(SPEEDHOTKEY)


;KEYS FOR RECORDING
recordmodkeys = AppsKey|!|#|+|CapsLock|Scrolllock|NumLock|LControl|LAlt|LShift|Tab|Backspace|Enter|Left|Right|Up|Down|Delete|Insert|Escape|Home|End|PgUp|PgDn|Numpad0|Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|NumpadDot|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|NumpadIns|NumpadEnd|NumpadDown|NumpadPgDn|NumpadLeft|NumpadClear|NumpadRight|NumpadHome|NumpadUp|NumpadPgUp|NumpadDel|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|Pause|Break|PrintScreen|LWin|RWin|RControl|RAlt|RShift|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|0|1|2|3|4|5|6|7|8|9|Space
recordmodshort = {AppsKey}|{!}|{#}|{+}||||^|!|+|{TAB}|{BS}|{ENTER}|{LEFT}|{RIGHT}|{UP}|{DOWN}|{DEL}|{INS}|{ESC}|{HOME}|{END}|{PGUP}|{PGDN}|{Numpad0}|{Numpad1}|{Numpad2}|{Numpad3}|{Numpad4}|{Numpad5}|{Numpad6}|{Numpad7}|{Numpad8}|{Numpad9}|{NumpadDot}|{NumpadDiv}|{NumpadMult}|{NumpadAdd}|{NumpadSub}|{NumpadEnter}|{NumpadIns}|{NumpadEnd}|{NumpadDown}|{NumpadPgDn}|{NumpadLeft}|{NumpadClear}|{NumpadRight}|{NumpadHome}|{NumpadUp}|{NumpadPgUp}|{NumpadDel}|{NumpadDiv}|{NumpadMult}|{NumpadAdd}|{NumpadSub}|{NumpadEnter}|{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}|{F13}|{F14}|{F15}|{F16}|{F17}|{F18}|{F19}|{F20}|{F21}|{F22}|{F23}|{F24}|{PAUSE}|{BREAK}|{PRINTSCREEN}|#|#|^|!|+|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|0|1|2|3|4|5|6|7|8|9|{Space}
StringSplit, recordmodkeys, recordmodkeys, |
StringSplit, recordmodshort, recordmodshort, |

;needed to check if DLLCALL parameters have "", not requiered here to use them
Transform, quotationmark, Chr, 34
;needed to separate macros also if and loop
Transform, macroseparator, Chr, 3
macroifloopblock := "{" . macroseparator
macroifloopblockend := macroseparator . "}"
Transform, programseparator, Chr, 2
;Used to determine if the command exists before running it, second is for information in MACRO MANAGEMENT and shows short commands, so use [S, 1000] instead of [Sleep, 1000]
workingcommands = AutoTrim|AT|BlockInput|BI|Break|Click|C|ClipWait|Continue|CW|Control|CTRL|ControlClick|CC|ControlFocus|CF|ControlGet|CG|ControlGetFocus|CGF|ControlGetPos|CGP|ControlGetText|CGT|ControlMove|CMO|ControlSend|CS|ControlSendRAW|CSR|ControlSetText|CST|CoordMode|CM|Critical|CR|DetectHiddenText|DHT|DetectHiddenWindows|DHW|DllCall|DC|Drive|D|DriveGet|DG|DriveSpaceFree|DSF|EnvAdd|EA|EnvDiv|ED|EnvGet|EG|EnvMult|EM|EnvSet|ES|EnvSub|ESU|EnvUpdate|EU|Exit|E|ExitApp|EAP|FileAppend|FA|FileCopy|FC|FileCopyDir|FCD|FileCreateDir|FCDIR|FileCreateShortcut|FCS|FileDelete|FD|FileGetAttrib|FGA|FileGetShortcut|FGSH|FileGetSize|FGS|FileGetTime|FGT|FileGetVersion|FGV|FileMove|FM|FileMoveDir|FMD|FileRead|FR|FileReadLine|FRL|FileRecycle|FRC|FileRecycleEmpty|FRE|FileRemoveDir|FRD|FileSelectFile|FSD|FileSelectFolder|FSF|FileSetAttrib|FSA|FileSetTime|FST|FormatTime|FT|GetKeyState|GKS|Gosub|GS|Goto|GT|GroupActivate|GA|GroupAdd|GADD|GroupClose|GCL|GroupDeactivate|GD|Gui|G|GuiControl|GC|GuiControlGet|GCG|Hotkey|H|If|IfEqual|IEQ|IfExist|IE|IfGreater|IG|IfGreaterOrEqual|IGOE|IfInString|IIS|IfLess|IL|IfLessOrEqual|ILOE|IfMsgBox|IMB|IfNotEqual|INEQ|IfNotExist|INE|IfNotInString|INIS|IfWinActive|IWA|IfWinExist|IWE|IfWinNotActive|IWNA|IfWinNotExist|IWNE|ImageSearch|IS|IniDelete|ID|IniRead|IR|IniWrite|IW|Input|I|InputBox|IB|KeyHistory|KH|KeyWait|KW|ListHotkeys|LH|ListVars|LV|Menu|M|MouseClick|MC|MouseClickDrag|MCD|MouseGetPos|MGP|MouseMove|MM|MsgBox|MB|OnExit|OE|OutputDebug|OD|Pause|P|PixelGetColor|PGC|PixelSearch|PS|PixelWaitColor|PWC|PostMessage|PM|Process|PR|Progress|PRG|Random|RND|RegDelete|RD|RegExMatch|REM|RegExReplace|RER|RegisterCallback|RC|RegRead|RR|RegWrite|RWR|Reload|RL|Run|R|RunAs|RA|RunWait|RW|Send|SN|SendEvent|SEV|SendInput|SI|SendMessage|SMSG|SendMode|SMOD|SendPlay|SP|SendRaw|SRAW|SetBatchLines|SBL|SetCapsLockState|SCLS|SetControlDelay|SCD|SetDefaultMouseSpeed|SDMS|SetEnv|SE|SetFormat|SF|SetKeyDelay|SKD|SetMouseDelay|SMD|SetNumLockState|SNLS|SetScrollLockState|SSLS|SetStoreCapslockMode|SSCM|SetTimer|ST|SetTitleMatchMode|STMM|SetWinDelay|SWD|SetWorkingDir|SWDIR|Shutdown|SD|Sleep|S|Sort|SO|SoundBeep|SB|SoundGet|SOG|SoundGetWaveVolume|SGWV|SoundPlay|SPL|SoundSet|SOS|SoundSetWaveVolume|SSWV|SplashImage|SIM|SplashTextOff|STOF|SplashTextOn|STON|SplitPath|SPTH|StatusBarGetText|SBGT|StatusBarWait|SBW|StringCaseSense|SCS|StringGetPos|SGP|StringLeft|SL|StringLen|SLEN|StringLower|SLOW|StringMid|SM|StringReplace|SRPL|StringRight|SR|StringSplit|SS|StringTrimLeft|STL|StringTrimRight|STR|StringUpper|SUP|Suspend|SU|SysGet|SG|Thread|T|ToolTip|TT|Transform|TR|TrayTip|TRT|URLDownloadToFile|UDTF|VarSetCapacity|VSC|WinActivate|WA|WinActivateBottom|WAB|WinClose|WC|WinGet|WG|WinGetActiveStats|WGAS|WinGetActiveTitle|WGAT|WinGetClass|WGC|WinGetPos|WGP|WinGetText|WGT|WinGetTitle|WGTT|WinHide|WH|WinKill|WK|WinMaximize|WMAX|WinMenuSelectItem|WMSI|WinMinimize|WMIN|WinMinimizeAll|WMA|WinMinimizeAllUndo|WMAU|WinMove|WM|WinRestore|WR|WinSet|WS|WinSetTitle|WST|WinShow|WSH|WinWait|WW|WinWaitActive|WWA|WinWaitClose|WWC|WinWaitNotActive|WWNA|
workingcommandsinfo = AutoTrim (AT)|BlockInput (BI)|Click (C)|ClipWait (CW)|Control (CTRL)|ControlClick (CC)|ControlFocus (CF)|ControlGet (CG)|ControlGetFocus (CGF)|ControlGetPos (CGP)|ControlGetText (CGT)|ControlMove (CMO)|ControlSend (CS)|ControlSendRAW (CSR)|ControlSetText (CST)|CoordMode (CM)|Critical (CR)|DetectHiddenText (DHT)|DetectHiddenWindows (DHW)|DllCall (DC)|Drive (D)|DriveGet (DG)|DriveSpaceFree (DSF)|EnvAdd (EA)|EnvDiv (ED)|EnvGet (EG)|EnvMult (EM)|EnvSet (ES)|EnvSub (ESU)|EnvUpdate (EU)|Exit (E)|ExitApp (EAP)|FileAppend (FA)|FileCopy (FC)|FileCopyDir (FCD)|FileCreateDir (FCDIR)|FileCreateShortcut (FCS)|FileDelete (FD)|FileGetAttrib (FGA)|FileGetShortcut (FGSH)|FileGetSize (FGS)|FileGetTime (FGT)|FileGetVersion (FGV)|FileMove (FM)|FileMoveDir (FMD)|FileRead (FR)|FileReadLine (FRL)|FileRecycle (FRC)|FileRecycleEmpty (FRE)|FileRemoveDir (FRD)|FileSelectFile (FSD)|FileSelectFolder (FSF)|FileSetAttrib (FSA)|FileSetTime (FST)|FormatTime (FT)|GetKeyState (GKS)|Gosub (GS)|Goto (GT)|GroupActivate (GA)|GroupAdd (GADD)|GroupClose (GCL)|GroupDeactivate (GD)|Gui (G)|GuiControl (GC)|GuiControlGet (GCG)|Hotkey (H)|If (If)|IfEqual (IEQ)|IfExist (IE)|IfGreater (IG)|IfGreaterOrEqual (IGOE)|IfInString (IIS)|IfLess (IL)|IfLessOrEqual (ILOE)|IfMsgBox (IMB)|IfNotEqual (INEQ)|IfNotExist (INE)|IfNotInString (INIS)|IfWinActive (IWA)|IfWinExist (IWE)|IfWinNotActive (IWNA)|IfWinNotExist (IWNE)|ImageSearch (IS)|IniDelete (ID)|IniRead (IR)|IniWrite (IW)|Input (I)|InputBox (IB)|KeyHistory (KH)|KeyWait (KW)|ListHotkeys (LH)|ListVars (LV)|Menu (M)|MouseClick (MC)|MouseClickDrag (MCD)|MouseGetPos (MGP)|MouseMove (MM)|MsgBox (MB)|OnExit (OE)|OutputDebug (OD)|Pause (P)|PixelGetColor (PGC)|PixelSearch (PS)|PixelWaitColor (PWC)|PostMessage (PM)|Process (PR)|Progress (PRG)|Random (RND)|RegDelete (RD)|RegExMatch (REM)|RegExReplace (RER)|RegisterCallback (RC)|RegRead (RR)|RegWrite (RWR)|Reload (RL)|Run (R)|RunAs (RA)|RunWait (RW)|Send (SN)|SendEvent (SEV)|SendInput (SI)|SendMessage (SMSG)|SendMode (SMOD)|SendPlay (SP)|SendRaw (SRAW)|SetBatchLines (SBL)|SetCapsLockState (SCLS)|SetControlDelay (SCD)|SetDefaultMouseSpeed (SDMS)|SetEnv (SE)|SetFormat (SF)|SetKeyDelay (SKD)|SetMouseDelay (SMD)|SetNumLockState (SNLS)|SetScrollLockState (SSLS)|SetStoreCapslockMode (SSCM)|SetTimer (ST)|SetTitleMatchMode (STMM)|SetWinDelay (SWD)|SetWorkingDir (SWDIR)|Shutdown (SD)|Sleep (S)|Sort (SO)|SoundBeep (SB)|SoundGet (SOG)|SoundGetWaveVolume (SGWV)|SoundPlay (SPL)|SoundSet (SOS)|SoundSetWaveVolume (SSWV)|SplashImage (SIM)|SplashTextOff (STOF)|SplashTextOn (STON)|SplitPath (SPTH)|StatusBarGetText (SBGT)|StatusBarWait (SBW)|StringCaseSense (SCS)|StringGetPos (SGP)|StringLeft (SL)|StringLen (SLEN)|StringLower (SLOW)|StringMid (SM)|StringReplace (SRPL)|StringRight (SR)|StringSplit (SS)|StringTrimLeft (STL)|StringTrimRight (STR)|StringUpper (SUP)|Suspend (SU)|SysGet (SG)|Thread (T)|ToolTip (TT)|Transform (TR)|TrayTip (TRT)|URLDownloadToFile (UDTF)|VarSetCapacity (VSC)|WinActivate (WA)|WinActivateBottom (WAB)|WinClose (WC)|WinGet (WG)|WinGetActiveStats (WGAS)|WinGetActiveTitle (WGAT)|WinGetClass (WGC)|WinGetPos (WGP)|WinGetText (WGT)|WinGetTitle (WGTT)|WinHide (WH)|WinKill (WK)|WinMaximize (WMAX)|WinMenuSelectItem (WMSI)|WinMinimize (WMIN)|WinMinimizeAll (WMA)|WinMinimizeAllUndo (WMAU)|WinMove (WM)|WinRestore (WR)|WinSet (WS)|WinSetTitle (WST)|WinShow (WSH)|WinWait (WW)|WinWaitActive (WWA)|WinWaitClose (WWC)|WinWaitNotActive (WWNA)


;SETINGS:
accellerationspeed = 1.6
standardspeed = 3
winwatcherspeed = 1
autostarton = ASK
webbrowserfile = %A_ProgramFiles%\Internet Explorer\iexplore
speedhotkeyon  =
debuggerison =
debuggerslowdown = 0
OnExit, mwt_RestoreAllThenExit
;Other
;tempvartempvar=
;programparamvar2=tempvartempvar
;programparamvar1=tempvartempvar

;Commands help in Macro Management CAPSLOCK & F5

Autohotkeyhelp =(AutoTrim, On|Off.AutoTrim [AT]`nDetermines whether "Var1 = %Var2%" statements omit spaces and tabs from the beginning and end of Var2)(BlockInput, Mode.BlockInput [BI]`nDisables or enables the user's ability to interact with the computer via keyboard and mouse)(Click OR Click, right, 10, 39 OR Click, down.Click [C]`nClicks a mouse button at the specified coordinatesIt can also hold down a mouse button, turn the mouse wheel, or move the mouse)(ClipWait [, SecondsToWait, 1].ClipWait [CW]`nWaits until the clipboard contains data)(Control, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText].Control [CTRL]`nMakes a variety of changes to a control)(ControlClick [, Control-or-Pos, WinTitle, WinText, WhichButton, ClickCount, Options, ExcludeTitle, ExcludeText].ControlClick [CC]`nSends a mouse button or mouse wheel event to a control)(ControlFocus [, Control, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlFocus [CF]`nSets input focus to a given control on a window)(ControlGet, OutputVar, Cmd [, Value, Control, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlGet [CG]`nRetrieves various types of information about a control)(ControlGetFocus, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlGetFocus [CGF]`nRetrieves which control of the target window has input focus, if any)(ControlGetPos [, X, Y, Width, Height, Control, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlGetPos [CGP]`nRetrieves the position and size of a control)(ControlGetText, OutputVar [, Control, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlGetText [CGT]`nRetrieves text from a control)(ControlMove, Control, X, Y, Width, Height [, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlMove [CMO]`nMoves or resizes a control)(ControlSend [, Control, Keys, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlSend [CS]`nSends simulated keystrokes to a window or control)(ControlSendRaw [, Control, Keys, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlSendRAW [CSR]`nSends simulated keystrokes to a window or control)(ControlSetText [, Control, NewText, WinTitle, WinText, ExcludeTitle, ExcludeText].ControlSetText [CST]`nChanges the text of a control)(CoordMode, ToolTip|Pixel|Mouse|Caret|Menu [, Screen|Relative].CoordMode [CM]`nSets coordinate mode for various commands to be relative to either the active window or the screen)(Critical [, ON|Off] OR Critical, 50.Critical [CR]`nPrevents the current thread from being interrupted by other threads)(DetectHiddenText, On|Off.DetectHiddenText [DHT]`nDetermines whether invisible text in a window is "seen" for the purpose of finding the windowThis affects commands such as IfWinExist and WinActivate)(DetectHiddenWindows, On|Off.DetectHiddenWindows [DHW]`nDetermines whether invisible windows are "seen" by the script)(DllCall,"[DllFile\]Function" [, Type1, Arg1, Type2, Arg2, "Cdecl ReturnType"].DllCall [DC]`nCalls a function inside a DLL, such as a standard Windows API function)(Drive, Sub-command [, Drive , Value].Drive [D]`nEjects/retracts the tray in a CD or DVD drive, or sets a drive's volume label)(DriveGet, OutputVar, Cmd [, Value].DriveGet [DG]`nRetrieves various types of information about the computer's drive[s])(DriveSpaceFree, OutputVar, Path.DriveSpaceFree [DSF]`nRetrieves the free disk space of a drive, in Megabytes)(EnvAdd, Var, Value [, TimeUnits].EnvAdd [EA]`nSets a variable to the sum of itself plus the given value [can also add or subtract time from a date-time value]Synonymous with: var += value)(EnvDiv, Var, Value.EnvDiv [ED]`nSets a variable to itself divided by the given valueSynonymous with: var /= value)(EnvGet, OutputVar, EnvVarName.EnvGet [EG]`nRetrieves an environment variable)(EnvMult, Var, Value.EnvMult [EM]`nSets a variable to itself times the given valueSynonymous with: var *= value)(EnvSet, EnvVar, Value.EnvSet [ES]`nWrites a value to a variable contained in the environment)(EnvSub, Var, Value [, TimeUnits].EnvSub [ESU]`nSets a variable to itself minus the given value [can also compare date-time values]Synonymous with: var -= value)(EnvUpdate.EnvUpdate [EU]`nNotifies the OS and all running applications that environment variable[s] have changed)(Exit [, ExitCode].Exit [E]`nExits the current thread or [if the script is not persistent contains no hotkeys] the entire script)(ExitApp [, ExitCode].ExitApp [EAP]`nTerminates the script unconditionally)(FileAppend [, Text, Filename].FileAppend [FA]`nWrites text to the end of a file [first creating the file, if necessary])(FileCopy, SourcePattern, DestPattern [, Flag].FileCopy [FC]`nCopies one or more files)(FileCopyDir, Source, Dest [, Flag].FileCopyDir [FCD]`nCopies a folder along with all its sub-folders and files [similar to xcopy])(FileCreateDir, DirName.FileCreateDir [FCDIR]`nCreates a directory/folder)(FileCreateShortcut, Target, LinkFile [, WorkingDir, Args, Description, IconFile, ShortcutKey, IconNumber, RunState].FileCreateShortcut [FCS]`nCreates a shortcut [lnk] file)(FileDelete, FilePattern.FileDelete [FD]`nDeletes one or more files)(FileGetAttrib, OutputVar [, Filename].FileGetAttrib [FGA]`nReports whether a file or folder is read-only, hidden, etc)(FileGetShortcut, LinkFile [, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState].FileGetShortcut [FGSH]`nRetrieves information about a shortcut [lnk] file, such as its target file)(FileGetSize, OutputVar [, Filename, Units].FileGetSize [FGS]`nRetrieves the size of a file)(FileGetTime, OutputVar [, Filename, WhichTime].FileGetTime [FGT]`nRetrieves the datetime stamp of a file or folder)(FileGetVersion, OutputVar [, Filename].FileGetVersion [FGV]`nRetrieves the version of a file)(FileMove, SourcePattern, DestPattern [, Flag].FileMove [FM]`nMoves or renames one or more files)(FileMoveDir, Source, Dest [, Flag].FileMoveDir [FMD]`nMoves a folder along with all its sub-folders and filesIt can also rename a folder)(FileRead, OutputVar, Filename.FileRead [FR]`nReads a file's text into a variable)(FileReadLine, OutputVar, Filename, LineNum.FileReadLine [FRL]`nReads the specified line from a file and stores the text in a variable)(FileRecycle, FilePattern.FileRecycle [FRC]`nSends a file or directory to the recycle bin, if possible)(FileRecycleEmpty [, DriveLetter].FileRecycleEmpty [FRE]`nEmpties the recycle bin)(FileRemoveDir, DirName [, Recurse?].FileRemoveDir [FRD]`nDeletes a folder)(FileSelectFile, OutputVar [, Options, RootDir\Filename, Prompt, Filter].FileSelectFile [FSD]`nDisplays a standard dialog that allows the user to open or save file[s])(FileSelectFolder, OutputVar [, StartingFolder, Options, Prompt].FileSelectFolder [FSF]`nDisplays a standard dialog that allows the user to select a folder)(FileSetAttrib, Attributes [, FilePattern, OperateOnFolders?, Recurse?].FileSetAttrib [FSA]`nChanges the attributes of one or more files or foldersWildcards are supported)(FileSetTime [, YYYYMMDDHH24MISS, FilePattern, WhichTime, OperateOnFolders?, Recurse?].FileSetTime [FST]`nChanges the datetime stamp of one or more files or foldersWildcards are supported)(FormatTime, OutputVar [, YYYYMMDDHH24MISS, Format].FormatTime [FT]`nTransforms a YYYYMMDDHH24MISS timestamp into the specified date/time format)(GetKeyState, OutputVar, KeyName [, Mode].GetKeyState [GKS]`nChecks if a keyboard key or mouse/joystick button is down or upAlso retrieves joystick status)(Gosub, Label.Gosub [GS]`nJumps to the specified label and continues execution until Return is encountered)(Goto, Label.Goto [GT]`nJumps to the specified label and continues execution)(GroupActivate, GroupName [, R].GroupActivate [GA]`nActivates the next window in a window group that was defined with GroupAdd)(GroupAdd, GroupName [, WinTitle, WinText, Label, ExcludeTitle, ExcludeText].GroupAdd [GADD]`nAdds a window specification to a window group, creating the group if necessary)(GroupClose, GroupName [, A|R].GroupClose [GCL]`nCloses the active window if it was just activated by GroupActivate or GroupDeactivateIt then activates the next window in the seriesIt can also close all windows in a group)(GroupDeactivate, GroupName [, R].GroupDeactivate [GD]`nSimilar to GroupActivate except activates the next window not in the group)(Gui, sub-command [, Param2, Param3, Param4].Gui [G]`nCreates and manages windows and controlsSuch windows can be used as data entry forms or custom user interfaces)(GuiControl, Sub-command, ControlID [, Param3].GuiControl [GC]`nMakes a variety of changes to a control in a GUI window)(GuiControlGet, OutputVar [, Sub-command, ControlID, Param4].GuiControlGet [GCG]`nRetrieves various types of information about a control in a GUI window)(Hotkey, KeyName [, Label, Options] OR Hotkey, IfWinActive/Exist [, WinTitle, WinText].Hotkey [H]`nCreates, modifies, enables, or disables a hotkey while the script is running)(if, Var, in, MatchList OR if, Var, not in, MatchList OR if, Var, contains, MatchList OR if, Var, not contains, MatchList OR if, Var, between, LowerBound, UpperBound OR if, Var not between, LowerBound, UpperBound OR if, var, is, type OR if, var, is not, type.If [If]`nChecks whether a variable's contents match one of the items in a list)(IfEqual, var, value [same: if var = value].IfEqual [IEQ]`nSpecifies the command[s] to perform if the comparison of a variable to a value evalutes to TRUEWhen more than one command is present, enclose them in a block [braces])(IfExist, FilePattern.IfExist [IE]`nChecks for the existence of a file or folder)(IfGreater, var, value.IfGreater [IG]`nSpecifies the command to perform if the comparison of a variable to a value evalutes to TRUE)(IfGreaterOrEqual, var, value.IfGreaterOrEqual [IGOE]`nSpecifies the command to perform if the comparison of a variable to a value evalutes to TRUE)(IfInString, var, SearchString.IfInString [IIS]`nChecks if a variable contains the specified string)(IfLess, var, value.IfLess [IL]`nSpecifies the command to perform if the comparison of a variable to a value evalutes to TRUE)(IfLessOrEqual, var, value.IfLessOrEqual [ILOE]`nSpecifies the command to perform if the comparison of a variable to a value evalutes to TRUE)(IfMsgBox, ButtonName.IfMsgBox [IMB]`nChecks which button was pushed by the user during the most recent MsgBox command)(IfNotEqual, var, value.IFNotEqual [INEQ]`nSpecifies the command to perform if the comparison of a variable to a value evalutes to TRUE)(IfNotExist, FilePattern.IfNotExist [INE]`nChecks for the existence of a file or folder)(IfNotInString, var, value.IfNotInString [INIS]`nSpecifies the command to perform if the comparison of a variable to a value evalutes to TRUE)(IfWinActive [, WinTitle, WinText, ExcludeTitle, ExcludeText].IfWinActive [IWA]`nChecks if the specified window exists and is currently active [foremost])(IfWinExist [, WinTitle, WinText, ExcludeTitle, ExcludeText].IfWinExist [IWE]`nChecks if the specified window exists)(IfWinNotActive [, WinTitle, WinText, ExcludeTitle, ExcludeText].IfWinNotActive [IWNA]`nChecks if the specified window exists and is currently active [foremost])(IfWinNotExist [, WinTitle, WinText, ExcludeTitle, ExcludeText].IfWinNotExist [IWNE]`nChecks if the specified window exists)(ImageSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ImageFile.ImageSearch [IS]`nSearches a region of the screen for an image)(IniDelete, Filename, Section [, Key].IniDelete [ID]`nDeletes a value from a standard format ini file)(IniRead, OutputVar, Filename, Section, Key [, Default].IniRead [IR]`nReads a value from a standard format ini file)(IniWrite, Value, Filename, Section, Key.IniWrite [IW]`nWrites a value to a standard format ini file)(Input [, OutputVar, Options, EndKeys, MatchList].Input [I]`nWaits for the user to type a string [not supported on Windows 9x: it does nothing])(InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default].InputBox [IB]`nDisplays an input box to ask the user to enter a string)(KeyHistory.KeyHistory [KH]`nDisplays script info and a history of the most recent keystrokes and mouse clicks)(KeyWait, KeyName [, Options].KeyWait [KW]`nWaits for a key or mouse/joystick button to be released or pressed down)(ListHotkeys.ListHotkeys [LH]`nDisplays the hotkeys in use by the current script, whether their subroutines are currently running, and whether or not they use the keyboard or mouse hook)(ListVars.ListVars [LV]`nDisplays the script's variables: their names and current contents)(Menu, MenuName, Cmd [, P3, P4, P5].Menu [M]`nCreates, deletes, modifies and displays menus and menu itemsChanges the tray icon and its tooltipControls whether the main window of a compiled script can be opened)(MouseClick [, WhichButton , X, Y, ClickCount, Speed, D|U, R].MouseClick [MC]`nClicks or holds down a mouse button, or turns the mouse wheelNOTE: The Click command is generally more flexible and easier to use)(MouseClickDrag, WhichButton, X1, Y1, X2, Y2 [, Speed, R].MouseClickDrag [MCD]`nClicks and holds the specified mouse button, moves the mouse to the destination coordinates, then releases the button)(MouseGetPos, [OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1|2|3].MouseGetPos [MGP]`nRetrieves the current position of the mouse cursor, and optionally which window and control it is hovering over)(MouseMove, X, Y [, Speed, R].MouseMove [MM]`nMoves the mouse cursor)(MsgBox, Text OR MsgBox [, Options, Title, Text, Timeout].MsgBox [MB]`nDisplays the specified text in a small window containing one or more buttons [such as Yes and No])(OnExit [, Label].OnExit [OE]`nSpecifies a subroutine to run automatically when the script exits)(OutputDebug, Text.OutputDebug [OD]`nSends a string to the debugger [if any] for display)(Pause [, On|Off|Toggle, OperateOnUnderlyingThread?].Pause [P]`nPauses the script's current thread)


Autohotkeyhelp = %autohotkeyhelp%(PixelGetColor, OutputVar, X, Y [, Alt|Slow|RGB].PixelGetColor [PGC]`nRetrieves the color of the pixel at the specified x,y screen coordinates)(PixelSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ColorID [, Variation, Fast|RGB].PixelSearch [PS]`nSearches a region of the screen for a pixel of the specified color)(PixelWaitColor, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ColorID [, Variation, Fast|RGB, Seconds, Interval].PixelWaitColor [PWC]`nWaits in a region of the screen for a pixel of the specified color)(PostMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText].PostMessage [PM]`nSends a message to a window or control)(Process, Cmd, PID-or-Name [, Param3].Process [PR]`nPerforms one of the following operations on a process: checks if it exists, changes its priority, closes it, waits for it to close)(Progress, Off OR Progress, ProgressParam1 [, SubText, MainText, WinTitle, FontName].Progress [PRG]`nCreates or updates a window containing a progress bar or an image)(Random, OutputVar [, Min, Max] OR Random, , NewSeed.Random [RND]`nGenerates a pseudo-random number)(RegDelete, RootKey, SubKey [, ValueName].RegDelete [RD]`nDeletes a subkey or value from the registry)(RegExMatch, Haystack, NeedleRegEx [, UnquotedOutputVar = "", StartingPosition = 1].RegExMatch [REM]`nDetermines whether a string contains a pattern [regular expression])(RegExReplace, Haystack, NeedleRegEx [, Replacement = "", OutputVarCount = "", Limit = -1, StartingPosition = 1].RegExReplace [RER]`nReplaces occurrences of a pattern [regular expression] inside a string)(RegisterCallback,"FunctionName" [, Options = "", ParamCount = FormalCount, EventInfo = Address].RegisterCallback [RC]`nCreates a machine-code address that when called, redirects the call to a function in the script)(RegRead, OutputVar, RootKey, SubKey [, ValueName].RegRead [RR]`nReads a value from the registry)(RegWrite, ValueType, RootKey, SubKey [, ValueName, Value].RegWrite [RWR]`nWrites a value to the registry)(Reload.Reload [RL]`nReplaces the currently running instance of the script with a new one)(Run, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID].Run [R]`nRuns an external programUnlike Run, RunWait will wait until the program finishes before continuing)(RunAs [, User, Password, Domain].RunAs [RA]`nRuns an external programUnlike Run, RunWait will wait until the program finishes before continuing)(RunWait, Target [, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID].RunWait [RW]`nRuns an external programUnlike Run, RunWait will wait until the program finishes before continuing)(Send, Keys.Send [SN]`nSends simulated keystrokes and mouse clicks to the active window)(SendEvent, Keys.SendEvent [SEV]`nSends simulated keystrokes and mouse clicks to the active window)(SendInput, Keys.SendInput [SI]`nSends simulated keystrokes and mouse clicks to the active window)(SendMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText].SendMessage [SMSG]`nSends a message to a window or control and additionally waits for acknowledgement)(SendMode, Input|Play|Event|InputThenPlay.SendMode [SMOD]`nMakes Send synonymous with SendInput or SendPlay rather than the default [SendEvent]Also makes Click and MouseMove/Click/Drag use the specified method)(SendPlay, Keys.SendPlay [SP]`nSends simulated keystrokes and mouse clicks to the active window)(SendRaw, Keys.SendRaw [SRAW]`nSends simulated keystrokes and mouse clicks to the active window)(SetBatchLines, 20ms OR SetBatchLines, LineCount.SetBatchLines [SBL]`nDetermines how fast a script will run [affects CPU utilization])(SetCapsLockState [, State].SetCapsLockState [SCLS]`nSets the state of the CapslockCan also force the key to stay on or off)(SetControlDelay, Delay.SetControlDelay [SCD]`nSets the delay that will occur after each control-modifying command)(SetDefaultMouseSpeed, Speed.SetDefaultMouseSpeed [SDMS]`nSets the mouse speed that will be used if unspecified in Click and MouseMove/Click/Drag)(SetEnv, Var, Value OR Var=Value.SetEnv [SE]`nAssigns the specified value to a variable)(SetFormat, NumberType, Format.SetFormat [SF]`nSets the format of integers and floating point numbers generated by math operations)(SetKeyDelay [, Delay, PressDuration, Play].SetKeyDelay [SKD]`nSets the delay that will occur after each keystroke sent by Send and ControlSend)(SetMouseDelay, Delay [, Play].SetMouseDelay [SMD]`nSets the delay that will occur after each mouse movement or click)(SetNumLockState [, State].SetNumLockState [SNLS]`nSets the state of the NumLock keyCan also force the key to stay on or off)(SetScrollLockState [, State].SetScrollLockState [SSLS]`nSets the state of the ScrollLock keyCan also force the key to stay on or off)(SetStoreCapslockMode, On|Off.SetStoreCapslockMode [SSCM]`nWhether to restore the state of CapsLock after a Send)(SetTimer, Label [, Period|On|Off, Priority].SetTimer [ST]`nCauses a subroutine to be launched automatically and repeatedly at a specified time interval)(SetTitleMatchMode, MatchMode OR SetTitleMatchMode, Fast|Slow.SetTitleMatchMode [STMM]`nSets the matching behavior of the WinTitle parameter in commands such as WinWait)(SetWinDelay, Delay.SetWinDelay [SWD]`nSets the delay that will occur after each windowing command, such as WinActivate)(SetWorkingDir, DirName.SetWorkingDir [SWDIR]`nChanges the script's current working directory)(Shutdown, Code.Shutdown [SD]`nShuts down, restarts, or logs off the system)(Sleep, DelayInMilliseconds.Sleep [S]`nWaits the specified amount of time before continuing)(Sort, VarName [, Options].Sort [SO]`nArranges a variable's contents in alphabetical, numerical, or random order [optionally removing duplicates])(SoundBeep [, Frequency, Duration].SoundBeep [SB]`nEmits a tone from the PC speaker)(SoundGet, OutputVar [, ComponentType, ControlType, DeviceNumber].SoundGet [SOG]`nRetrieves various settings from a sound device [master mute, master volume, etc])(SoundGetWaveVolume, OutputVar [, DeviceNumber].SoundGetWaveVolume [SGWV]`nRetrieves the wave output volume for a sound device)(SoundPlay, Filename [, wait].SoundPlay [SPL]`nPlays a sound, video, or other supported file type)(SoundSet, NewSetting [, ComponentType, ControlType, DeviceNumber].SoundSet [SOS]`nChanges various settings of a sound device [master mute, master volume, etc])(SoundSetWaveVolume, Percent [, DeviceNumber].SoundSetWaveVolume [SSWV]`nChanges the wave output volume for a sound device)(SplashImage, Off OR SplashImage [, ImageFile, Options, SubText, MainText, WinTitle, FontName].SplashImage [SIM]`nCreates or updates a window containing a progress bar or an image)(SplashTextOff.SplashTextOff [STOF]`nCreates a customizable text popup window)(SplashTextOn [, Width, Height, Title, Text].SplashTextOn [STON]`nCreates a customizable text popup window)(SplitPath, InputVar [, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive].SplitPath [SPTH]`nSeparates a file name or URL into its name, directory, extension, and drive)(StatusBarGetText, OutputVar [, Part#, WinTitle, WinText, ExcludeTitle, ExcludeText].StatusBarGetText [SBGT]`nRetrieves the text from a standard status bar control)(StatusBarWait [, BarText, Seconds, Part#, WinTitle, WinText, Interval, ExcludeTitle, ExcludeText].StatusBarWait [SBW]`nWaits until a window's status bar contains the specified string)(StringCaseSense, On|Off|Locale.StringCaseSense [SCS]`nDetermines whether string comparisons are case sensitive [default is "not case sensitive"])(StringGetPos, OutputVar, InputVar, SearchText [, L#|R#, Offset].StringGetPos [SGP]`nRetrieves the position of the specified substring within a string)(StringLeft, OutputVar, InputVar, Count.StringLeft [SL]`nRetrieves a number of characters from the left-hand side of a string)(StringLen, OutputVar, InputVar.StringLen [SLEN]`nRetrieves the count of how many characters are in a string)(StringLower, OutputVar, InputVar [, T].StringLower [SLOW]`nConverts a string to lowercase)(StringMid, OutputVar, InputVar, StartChar [, Count , L].StringMid [SM]`nRetrieves one or more characters from the specified position in a string)(StringReplace, OutputVar, InputVar, SearchText [, ReplaceText, ReplaceAll?].StringReplace [SRPL]`nReplaces the specified substring with a new string)(StringRight, OutputVar, InputVar, Count.StringRight [SR]`nRetrieves a number of characters from the right-hand side of a string)(StringSplit, OutputArray, InputVar [, Delimiters, OmitChars].StringSplit [SS]`nSeparates a string into an array of substrings using the specified delimiters)(StringTrimLeft, OutputVar, InputVar, Count.StringTrimLeft [STL]`nRemoves a number of characters from the left-hand side of a string)(StringTrimRight, OutputVar, InputVar, Count.StringTrimRight [STR]`nRemoves a number of characters from the right-hand side of a string)(StringUpper, OutputVar, InputVar [, T].StringUpper [SUP]`nConverts a string to uppercase)(Suspend [, Mode].Suspend [SU]`nDisables or enables all or selected hotkeys)(SysGet, OutputVar, Sub-command [, Param3].SysGet [SG]`nRetrieves screen resolution, multi-monitor info, dimensions of system objects, and other system properties)(Thread, NoTimers [, false] OR Thread, Priority, n.Thread [T]`nSets the priority or interruptibility of threadsIt can also temporarily disable all timers)(ToolTip [, Text, X, Y, WhichToolTip].ToolTip [TT]`nCreates an always-on-top window anywhere on the screen)(Transform, OutputVar, Cmd, Value1 [, Value2].Transform [TR]`nPerforms miscellaneous math functions, bitwise operations, and tasks such as ASCII/Unicode conversion)(TrayTip [, Title, Text, Seconds, Options].TrayTip [TRT]`nCreates a balloon message window near the tray iconRequires Windows 2000/XP or later)(UrlDownloadToFile, URL, Filename.URLDownloadToFile [UDTF]`nDownloads a file from the Internet)(VarSetCapacity,UnquotedVarName [, RequestedCapacity, FillByte].VarSetCapacity [VSC]`nEnlarges a variable's holding capacity or frees its memoryNormally, this is necessary only for unusual circumstances such as DllCall)(WinActivate [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinActivate [WA]`nActivates the specified window [makes it foremost])(WinActivateBottom [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinActivateBottom [WAB]`nSame as WinActivate except that it activates the bottommost [least recently active] matching window rather than the topmost)(WinClose [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText].WinClose [WC]`nCloses the specified window)(WinGet, OutputVar [, Cmd, WinTitle, WinText, ExcludeTitle, ExcludeText].WinGet [WG]`nRetrieves the specified window's unique ID, process ID, process name, or a list of its controlsIt can also retrieve a list of all windows matching the specified criteria)(WinGetActiveStats, Title, Width, Height, X, Y.WinGetActiveStats [WGAS]`nCombines the functions of WinGetActiveTitle and WinGetPos into one command)(WinGetActiveTitle, OutputVar.WinGetActiveTitle [WGAT]`nRetrieves the title of the active window)(WinGetClass, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinGetClass [WGC]`nRetrieves the specified window's class name)(WinGetPos [, X, Y, Width, Height, WinTitle, WinText, ExcludeTitle, ExcludeText].WinGetPos [WGP]`nRetrieves the position and size of the specified window)(WinGetText, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinGetText [WGT]`nRetrieves the text from the specified window)(WinGetTitle, OutputVar [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinGetTitle [WGTT]`nRetrieves the title of the specified window)(WinHide [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinHide [WH]`nHides the specified window)(WinKill [, WinTitle, WinText, SecondsToWait, ExcludeTitle, ExcludeText].WinKill [WK]`nForces the specified window to close)(WinMaximize [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinMaximize [WMAX]`nEnlarges the specified window to its maximum size)(WinMenuSelectItem, WinTitle, WinText, Menu [, SubMenu1, SubMenu2, SubMenu3, SubMenu4, SubMenu5, SubMenu6, ExcludeTitle, ExcludeText].WinMenuSelectItem [WMSI]`nInvokes a menu item from the menu bar of the specified window)(WinMinimize [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinMinimize [WMIN]`nCollapses the specified window into a button on the task bar)(WinMinimizeAll.WinMinimizeAll [WMA]`nMinimizes all windows)(WinMinimizeAllUndo.WinMinimizeAllUndo [WMAU]`nUnminimizes all window)(WinMove, X, Y OR WinMove, WinTitle, WinText, X, Y [, Width, Height, ExcludeTitle, ExcludeText].WinMove [WM]`nChanges the position and/or size of the specified window)(WinRestore [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinRestore [WR]`nUnminimizes or unmaximizes the specified window if it is minimized or maximized)(WinSet, Attribute, Value [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinSet [WS]`nMakes a variety of changes to the specified window, such as "always on top" and transparency)(WinSetTitle, NewTitle OR WinSetTitle, WinTitle, WinText, NewTitle [, ExcludeTitle, ExcludeText].WinSetTitle [WST]`nChanges the title of the specified window)(WinShow [, WinTitle, WinText, ExcludeTitle, ExcludeText].WinShow [WSH]`nUnhides the specified window)(WinWait [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText].WinWait [WW]`nWaits until the specified window exists)(WinWaitActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText].WinWaitActive [WWA]`nWaits until the specified window is active)(WinWaitClose [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText].WinWaitClose [WWC]`nWaits until the specified window does not exist)(WinWaitNotActive [, WinTitle, WinText, Seconds, ExcludeTitle, ExcludeText].WinWaitNotActive [WWNA]`nWaits until the specified window is not active)


;Loop, 10 ;Creates clipboard variables 1 - 10
;	clipboard%A_Index% =
;TrayTip, , WIRD GESTARTET ..., 10	, 1
ToolTip, `n %SCRIPTNAME_VAR% wird gestartet... `n,0,50, 20
;KeyWait, CAPSLOCK, T5
;SetCapslockState, Off

;Will keep window for passwort in front
SetTimer, alwaysontopwindow, 500

Neuespassword: ;Password will be checked and reseted if so wanted
{	
	IniRead, pwchkcounted, %config%, DEFAULT, F93DHH98E08776AC, ERROR
	If pwchkcounted = ERROR
	{
		InputBox, passwordchecking, New Password:, , HIDE, 160, 100, , , , 120
		If (Errorlevel = "1" or Errorlevel = "2")
			ExitApp
		Encrypt(passwordchecking, config)
		VarSetCapacity(passwordchecking, 0)
	}
	else
	{
		FileRead, pwchkcountedchk, %pwchkcounted%
		If (pwchkcountedchk !="")
		{
			InputBox, passwordcheckingin, Password:,, HIDE, 160, 100, , , , 120
			If (Errorlevel = "1" or Errorlevel = "2")
			ExitApp
			else
			{
				passwordchecking = %passwordcheckingin%
			}
			Decrypt(passwordchecking, config)
			If (passwordcheckingin <> passwordchecking)
			ExitApp
			VarSetCapacity(passwordcheckingin,0)
			VarSetCapacity(passwordchecking,0)
		}
	}
	Sleep, 100
	SetFormat, FLOAT, 0.16
}

StringCaseSense, Off
SetCapsLockState, Off

;HOTKEYS

Hotkey, ^<, Runvariable
Hotkey, CTRL & RETURN, Runvariable
Hotkey, CTRL & CAPSLOCK, Speedhotkey
;Hotkey, ALT & SPACE, Eingabe_Starten
Hotkey, CAPSLOCK & F1, Changeprofile
Hotkey, CAPSLOCK & F2, Runvar
Hotkey, CAPSLOCK & CTRL, Runvar
Hotkey, CAPSLOCK & F3, mwt_UnMinimize
Hotkey, CAPSLOCK & F4, mwt_Minimize
Hotkey, CAPSLOCK & F5, Macrokeys
Hotkey, CAPSLOCK & F7, Listhotkeys
Hotkey, CAPSLOCK & F8, SETUPMACRO
Hotkey, CAPSLOCK & F9, HilfeBox
Hotkey, CAPSLOCK & F11, StopMacro
Hotkey, CAPSLOCK & F12, RestartProgram
Hotkey, CAPSLOCK & ENTER, Speedhotkey
Hotkey, CAPSLOCK & ESC, Speedhotkey
Hotkey, CAPSLOCK & BACKSPACE, Speedhotkey
Hotkey, SCROLLLOCK & BACKSPACE, Speedhotkey
Hotkey, NUMLOCK & BACKSPACE, Speedhotkey
Hotkey, CAPSLOCK & SHIFT, FILEEXPLORER
Hotkey, CAPSLOCK & TAB, Eingabe_Starten
Hotkey, CAPSLOCK & SPACE, WINWATCHER
Hotkey, CAPSLOCK & PAUSE, EDITOR
Hotkey, CAPSLOCK & SC01B, AddWatch, Off
Hotkey, CAPSLOCK & -, RemoveWatch, Off
Hotkey, CAPSLOCK & ALT, ShowHideGui, Off
Hotkey, ^+LButton , define_region, Off
Hotkey, ~LButton, RecordMouse, Off
Hotkey, ~RButton, RecordMouse, Off
;Hotkey, CAPSLOCK & UP, Mouse
;Hotkey, CAPSLOCK & DOWN, Mouse
;Hotkey, CAPSLOCK & LEFT, Mouse
;Hotkey, CAPSLOCK & RIGHT, Mouse
Hotkey, ~LEFT & UP, Mouse
Hotkey, ~LEFT & DOWN, Mouse
Hotkey, ~RIGHT & UP, Mouse
Hotkey, ~RIGHT & DOWN, Mouse
Hotkey, ~UP & LEFT, Mouse
Hotkey, ~UP & RIGHT, Mouse
Hotkey, ~DOWN & LEFT, Mouse
Hotkey, ~DOWN & RIGHT, Mouse
Hotkey, ~DOWN & UP, Mouse
Hotkey, ~UP & DOWN, Mouse
Hotkey, ~LEFT & RIGHT, Mouse
Hotkey, ~RIGHT & LEFT, Mouse
Hotkey, ~DOWN & CAPSLOCK, MouseSpeed
Hotkey, ~UP & CAPSLOCK, MouseSpeed
Hotkey, ~LEFT & CAPSLOCK, MouseSpeed
Hotkey, ~RIGHT & CAPSLOCK, MouseSpeed
Hotkey, NUMLOCK & NUMPAD1, RunNumLock
Hotkey, NUMLOCK & NUMPAD2, RunNumLock
Hotkey, NUMLOCK & NUMPAD3, RunNumLock
Hotkey, NUMLOCK & NUMPAD4, RunNumLock
Hotkey, NUMLOCK & NUMPAD5, RunNumLock
Hotkey, NUMLOCK & NUMPAD6, RunNumLock
Hotkey, NUMLOCK & NUMPAD7, RunNumLock
Hotkey, NUMLOCK & NUMPAD8, RunNumLock
Hotkey, NUMLOCK & NUMPAD9, RunNumLock
Hotkey, NUMLOCK & NUMPAD0, RunNumLock
Hotkey, NUMLOCK & NUMPADINS, RunNumLock
Hotkey, NUMLOCK & NUMPADRIGHT, RunNumLock
Hotkey, NUMLOCK & NUMPADEND, RunNumLock
Hotkey, NUMLOCK & NUMPADDOWN, RunNumLock
Hotkey, NUMLOCK & NUMPADPGDN, RunNumLock
Hotkey, NUMLOCK & NUMPADLEFT, RunNumLock
Hotkey, NUMLOCK & NUMPADCLEAR, RunNumLock
Hotkey, NUMLOCK & NUMPADHOME, RunNumLock
Hotkey, NUMLOCK & NUMPADUP, RunNumLock
Hotkey, NUMLOCK & NUMPADPGUP, RunNumLock
Hotkey, NUMLOCK & NUMPADDOT, RunNumLock
Hotkey, NUMLOCK & NUMPADDEL, RunNumLock
Hotkey, NUMLOCK & NUMPADDIV, RunNumLock
Hotkey, NUMLOCK & NUMPADMULT, RunNumLock
Hotkey, NUMLOCK & NUMPADADD, RunNumLock
Hotkey, NUMLOCK & NUMPADSUB, RunNumLock
Hotkey, NUMLOCK & NUMPADENTER, RunNumLock

;Numpad hotkeys
Loop %numkeys0%
{
	StringSplit, numkeyshotkey, numkeys%A_Index%
	Hotkey, NUMPAD%numkeyshotkey1% & NUMPAD%numkeyshotkey2%, RunHotkey, Off
}

	
;TRAYMENU
Menu, MySubmenu, add, &MACRO MANAGEMENT, Macrokeys
Menu, MySubmenu, add, &FILE EXPLORER, fileexplorer
Menu, MySubmenu, add, &CHANGE PROFILE, Changeprofile
Menu, MySubmenu, add, MONITOR &WINDOWS, WINWATCHER
Menu, MySubMenu, add, &SET UP NEW KEYWORD/MACRO, SETUPMACRO
Menu, tray, add
Menu, tray, add, &COMMANDS, :MySubmenu
Menu, tray, add
Menu, Tray, Add, &Unhide All Hidden Windows, mwt_RestoreAll
Menu, Tray, Add  ; Another separator line to make the above more special.
Menu, Tray, Tip, %SCRIPTNAME_VAR%

mwt_MaxLength = 260  ; Reduce this to restrict the width of the menu.
Gosub, Restartini

;QWERTY TASTATUR
RegRead KLang, HKEY_CURRENT_USER, Keyboard Layout\Preload, 1
StringRight KLang, KLang, 4
If (!KLang)
  KLang := A_Language

If (KLang = "0407") {
  ; 0407 DE_de QWERTZ mirror set
  original := "^12345qwertasdfgyxcvb"
  mirrored := "ß09876poiuzölkjh-.,mn"
} Else If (KLang = "040c" || KLang = "040C") {
  ; 040c FR_fr AZERTY mirror set         
  original := "²&é" . """" . "'(azertqsdfgwxcvb"   ; split up string for better
  mirrored := ")àç" . "_"  . "è-poiuymlkjh!:;,n"   ; human readability
} Else {
  ; 0409 US_us QWERTY mirror set
  original := "``" . "12345qwertasdfgzxcvb"   ; split up string for better
  mirrored := "'"  . "09876poiuy;lkjh/.,mn"   ; human readability
}
; Now define all hotkeys
Loop % StrLen(original){
  onehandc1 := SubStr(original, A_Index, 1)
  onehandc2 := SubStr(mirrored, A_Index, 1)
  Hotkey Space & %onehandc1%, DoHotkey
  Hotkey Space & %onehandc2%, DoHotkey
  Hotkey Space & %onehandc1%, Off
  Hotkey Space & %onehandc2%, Off
}
Hotkey, Space, Off
Hotkey, Space & CapsLock, Off
Hotkey, Space & Tab, Off
Hotkey, +Space, Off

ToolTip, -------------`n%SCRIPTNAME_VAR%`n-------------`nTO START `t`t- CAPSLOCK + TAB`nFOR HELP `t`t- CAPSLOCK + F9`nMACROMANAGEMENT `t- CAPSLOCK + F5`nCANCEL `t`t- ESC,0,50, 20
SetTimer, RemoveToolTip, 10000
return

; QWERTY ADDITIONAL. Not exactly mirror but as close as we can get, Capslock enter, Tab backspace.
Space & CapsLock::Send {Enter}
Space & Tab::Send {Backspace}
Space::Send {Space}
+Space::Send +{Space}
~Control & Space::Send ^{Space}

;WILL ASK YOU WETHER TO STOP MACRO
~Pause::
{
	MsgBox, 4, %SCRIPTNAME_VAR% STOP MACRO, DO YOU WANT TO STOP CURRENTLY RUNNING MACRO
	IfMsgBox Yes
	{
		scriptfirstrun = NO
		breaksendkeys = 1
	}
	else
		breaksendkeys =
	Return
}

;HIDE STARTUP DISPLAY
~ESCAPE::
{
	ToolTip,,,,20
	Return
}

; Keyboard Mouse
CAPSLOCK & LEFT::CLICK L
CAPSLOCK & RIGHT::CLICK R

;Click and hold down Left mouse, click again to release
CAPSLOCK & UP::
{
	GetKeyState, mouseisdown, LBUTTON, P
	If mouseisdown = U
		Click down
	else
		Click up
	Return
}
;Click and hold down Right mouse, click again to release
CAPSLOCK & DOWN::
{
	GetKeyState, mouseisdown, RBUTTON, P
	If mouseisdown = D
		Click up right
	else
		Click down right
	Return
}

;Auto replace [ with [], { with {} and % with %% in macro management. 
;CTRL & S will save macro
#IfWinActive HotKeyIt MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE AHK_class AutoHotkeyGUI
^s::GoSub ChangeMacrokeysfile
!O::
	ControlFocus, HiEdit1, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE AHK_class AutoHotkeyGUI
	Send ^{HOME}
Return
SHIFT & 5::Send `%`%{LEFT}
RALT & 7::
	SendRaw {}
	Send {Left}
Return
#IfWinActive


#IfWinActive HiEdit AHK_class AutoHotkeyGUI
F3:: FindNext(hedit)
^F:: CmnDlg_Find( hwnd, "OnFind" )
^G:: GoToLine()
^O:: GoTo Open_File
^S:: Goto Save_File
^N:: Goto New_File
^W:: Goto Close_File
#IfWinActive

#IfWinActive AHK EDITOR AHK_class AutoHotkeyGUI
F3:: FindNext(hedit)
^F:: CmnDlg_Find( hwnd, "OnFind" )
^G:: GoToLine()
^O:: GoTo Open_File
^S:: Goto Save_File
^N:: Goto New_File
^W:: Goto Close_File
#IfWinActive

CAPSLOCK & F10::Suspend
	
;Start main GUI
~LCONTROL::
{
	KeyWait, LControl, T0.2
	If Errolevel = 1
	return
	Sleep, 30
	KeyWait, LShift, D T0.4
	If Errorlevel = 1
	return
	Sleep, 10
	KeyWait, LShift, T0.2
	If Errorlevel = 0
	{
		Goto, Eingabe_Starten
	}
	return
}

;Pause Macro
StopMacro:
Pause, Toggle, 1
Return

;Keep enter password window on top
Alwaysontopwindow:
	SetTimer, alwaysontopwindow, Off
	WinWait, Password: ahk_class #32770, , 1
	If Errorlevel = 1
		Return
	WinSet, AlwaysOnTop, On, Password:
	Loop
	{
		IfWinNotExist, Password:
			break
		WinActivate, Password:
		Sleep, 50
	}
Return

;Speedhotkeys ON/OFF like A & B, D & 9, P & R...
Speedhotkey:
{
	ToolTip,,,,20
	KeyWait, CAPSLOCK
	KeyWait, CONTROL
	KeyWait, ESCAPE
	If speedhotkeyon = EIN
	{
		ToolTip, TURNING SPEEDKEYS OFF..., , , 19
		Loop %numkeys0%
		{
			StringSplit, numkeyshotkey, numkeys%A_Index%
			Hotkey, NUMPAD%numkeyshotkey1% & NUMPAD%numkeyshotkey2%, Off
		}
		Loop %hotkeyslist0%
		{
			StringLeft, hotkeya, hotkeyslist%A_Index%, 1
			StringRight, hotkeyb, hotkeyslist%A_Index%, 1
			Hotkey, %hotkeya% & %hotkeyb%, Off
		}
		speedhotkeyon = AUS
		Hotkey, CAPSLOCK & TAB, ON
		Hotkey, ~LCONTROL, ON
		Hotkey, CAPSLOCK & SHIFT, ON
		ToolTip, , , , 19
	}
	else
	{
		ToolTip, TURNING SPEEDKEYS ON..., , , 19
		Loop %numkeys0%
		{
			StringSplit, numkeyshotkey, numkeys%A_Index%
			Hotkey, NUMPAD%numkeyshotkey1% & NUMPAD%numkeyshotkey2%, On
		}
		Loop %hotkeyslist0%
		{
			StringLeft, hotkeya, hotkeyslist%A_Index%, 1
			StringRight, hotkeyb, hotkeyslist%A_Index%, 1
			Hotkey, %hotkeya% & %hotkeyb%, On
		}
		speedhotkeyon = EIN
		Hotkey, CAPSLOCK & TAB, OFF
		Hotkey, ~LCONTROL, OFF
		Hotkey, CAPSLOCK & SHIFT, OFF
		ToolTip, SPEEDHOTKEY ON, , , 19
	}
	BlockInput, Off
	Return
}

;CAPSLOCK & F12 to restart program
RestartProgram:
{
KeyWait, CAPSLOCK
SetCapsLockState, Off
Reload
Return
}

;Enter an environment variable in any explorer address bar and press CTRL & ENTER
RUNVARIABLE:
{
	Send, {DEL}{SHIFTDOWN}5{SHIFTUP}{HOME}{SHIFTDOWN}5{SHIFTUP}{ENTER}
	return
}

REMOVETOOLTIP:
{
	ToolTip,,,,20
	SetTimer, RemoveToolTip, Off
	EmptyMem()
	Return
}

;Emptys Memory
EmptyMem(PID="AHK Rocks"){
    pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
	}



;__________________________________________________________
;#Include settings.txt
1Include_settings:
SETUPMACRO:
{
	ToolTip,,,,20
	SetTimer, RemoveToolTip, Off
	setupnew =
	setupkey =
	setupname =
	setupprogramm =
	inputoptions = L1
	ToolTip, SETTINGS/MACROS:`tCANCEL WITH ESC`n`nPRESS:`n - I  TO SET UP A WEBSEITE`n - P TO SET UP A PROGRAM & FILES`n - O TO SET UP A FOLDER`n - M TO SET UP A MACRO`n - S TO BACKUP`n - R TO RESTORE
	Input, setupnew, L1, {ESC}
	If Errorlevel = EndKey:Escape
	{
		ToolTip,
		Exit
	}
	If (setupnew = "s" or setupnew = "r" or setupnew = "i" or setupnew = "p" or setupnew = "o" or setupnew = "m")
	ToolTip, %setupnew%
	else
	{
		ToolTip,
		Exit
	}
	savedirfile =
	If setupnew = s
	{
		ToolTip,
		FileRead, savedirfilecontent, %config%
		FileDelete, %SCRIPTNAME_VAR%config.bak
		FileAppend, %savedirfilecontent%, %SCRIPTNAME_VAR%config.bak
		MsgBox, 0, BACKUP, %SCRIPTNAME_VAR%config.bak was saved in %A_WorkingDir%, 5
		Return
	}
	else if setupnew = r
	{
		GoTo, Restoreini
	}
	count = 1
	setupparam =
	setupparamv =
	setupsave =
	setupparamvleer =
	Loop
	{
			;MsgBox, %count%
			If StrLen(setupparamv) < 101
				ToolTip, %setupparamv%
			else
			{
				If StrLen(setupparamv) < 201
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-101)*-1)
				else if StrLen(setupparamv) < 301
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-201)*-1)
				else if StrLen(setupparamv) < 401
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-301)*-1)
				else if StrLen(setupparamv) < 501
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-401)*-1)
				else if StrLen(setupparamv) < 601
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-501)*-1)
				else if StrLen(setupparamv) < 701
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-601)*-1)
				else if StrLen(setupparamv) < 801
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-701)*-1)
				else if StrLen(setupparamv) < 901
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-801)*-1)
				else if StrLen(setupparamv) < 1001
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-901)*-1)
				else if StrLen(setupparamv) < 1101
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1001)*-1)
				else if StrLen(setupparamv) < 1201
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1101)*-1)
				else if StrLen(setupparamv) < 1301
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1201)*-1)
				else if StrLen(setupparamv) < 1401
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1301)*-1)
				else if StrLen(setupparamv) < 1501
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1401)*-1)
				else if StrLen(setupparamv) < 1601
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1501)*-1)
				else if StrLen(setupparamv) < 1701
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1601)*-1)
				else if StrLen(setupparamv) < 1801
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1701)*-1)
				else if StrLen(setupparamv) < 1901
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1801)*-1)
				else if StrLen(setupparamv) < 2001
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-1901)*-1)
				else if StrLen(setupparamv) < 2101
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2001)*-1)
				else if StrLen(setupparamv) < 2201
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2101)*-1)
				else if StrLen(setupparamv) < 2301
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2201)*-1)
				else if StrLen(setupparamv) < 2401
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2301)*-1)
				else if StrLen(setupparamv) < 2501
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2401)*-1)
				else if StrLen(setupparamv) < 2601
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2501)*-1)
				else if StrLen(setupparamv) < 2701
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2601)*-1)
				else if StrLen(setupparamv) < 2801
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2701)*-1)
				else if StrLen(setupparamv) < 2901
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2801)*-1)
				else if StrLen(setupparamv) < 3001
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-2901)*-1)
				else if StrLen(setupparamv) < 3101
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3001)*-1)
				else if StrLen(setupparamv) < 3201
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3101)*-1)
				else if StrLen(setupparamv) < 3301
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3201)*-1)
				else if StrLen(setupparamv) < 3401
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, 3201, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3301)*-1)
				else if StrLen(setupparamv) < 3501
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, 3201, 100) . "`n" . SubStr(setupparamv, 3301, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3401)*-1)
				else if StrLen(setupparamv) < 3601
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, 3201, 100) . "`n" . SubStr(setupparamv, 3301, 100) . "`n" . SubStr(setupparamv, 3401, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3501)*-1)
				else if StrLen(setupparamv) < 3701
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, 3201, 100) . "`n" . SubStr(setupparamv, 3301, 100) . "`n" . SubStr(setupparamv, 3401, 100) . "`n" . SubStr(setupparamv, 3501, 100) . "`n" .  "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3601)*-1)
				else if StrLen(setupparamv) < 3801
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, 3201, 100) . "`n" . SubStr(setupparamv, 3301, 100) . "`n" . SubStr(setupparamv, 3401, 100) . "`n" . SubStr(setupparamv, 3501, 100) . "`n" . SubStr(setupparamv, 3601, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3701)*-1)
				else if StrLen(setupparamv) < 3901
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, 3201, 100) . "`n" . SubStr(setupparamv, 3301, 100) . "`n" . SubStr(setupparamv, 3401, 100) . "`n" . SubStr(setupparamv, 3501, 100) . "`n" . SubStr(setupparamv, 3601, 100) . "`n" . SubStr(setupparamv, 3701, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3801)*-1)
				else if StrLen(setupparamv) < 4001
					ToolTip % SubStr(setupparamv, 1, 100) . "`n" . SubStr(setupparamv, 101, 100) . "`n" . SubStr(setupparamv, 201, 100) . "`n" . SubStr(setupparamv, 301, 100) . "`n" . SubStr(setupparamv, 401, 100) . "`n" . SubStr(setupparamv, 501, 100) . "`n" . SubStr(setupparamv, 601, 100) . "`n" . SubStr(setupparamv, 701, 100) . "`n" . SubStr(setupparamv, 801, 100) . "`n" . SubStr(setupparamv, 901, 100) . "`n" . SubStr(setupparamv, 1001, 100) . "`n" . SubStr(setupparamv, 1101, 100) . "`n" . SubStr(setupparamv, 1201, 100) . "`n" . SubStr(setupparamv, 1301, 100) . "`n" . SubStr(setupparamv, 1401, 100) . "`n" . SubStr(setupparamv, 1501, 100) . "`n" . SubStr(setupparamv, 1601, 100) . "`n" . SubStr(setupparamv, 1701, 100) . "`n" . SubStr(setupparamv, 1801, 100) . "`n" . SubStr(setupparamv, 1901, 100) . "`n" . SubStr(setupparamv, 2001, 100) . "`n" . SubStr(setupparamv, 2101, 100) . "`n" . SubStr(setupparamv, 2201, 100) . "`n" . SubStr(setupparamv, 2301, 100) . "`n" . SubStr(setupparamv, 2401, 100) . "`n" . SubStr(setupparamv, 2501, 100) . "`n" . SubStr(setupparamv, 2601, 100) . "`n" . SubStr(setupparamv, 2701, 100) . "`n" . SubStr(setupparamv, 2801, 100) . "`n" . SubStr(setupparamv, 2901, 100) . "`n" . SubStr(setupparamv, 3001, 100) . "`n" . SubStr(setupparamv, 3101, 100) . "`n" . SubStr(setupparamv, 3201, 100) . "`n" . SubStr(setupparamv, 3301, 100) . "`n" . SubStr(setupparamv, 3401, 100) . "`n" . SubStr(setupparamv, 3501, 100) . "`n" . SubStr(setupparamv, 3601, 100) . "`n" . SubStr(setupparamv, 3701, 100) . "`n" . SubStr(setupparamv, 3801, 100) . "`n" . SubStr(setupparamv, (StrLen(setupparamv)-3901)*-1)
				else
					ToolTip % "..." . SubStr(setupparamv, -100)
			}
			If setupparam = 1
			{
				If  setupparamvleer = 1
					ToolTip, %setupparamv%%A_Space%
				If setupparamv =
				{
					If setupnew = i
						ToolTip, ENTER WEBSITE AND PRESS ENTER`n`nCANCEL WITH ESC`nALT+V = PASTE FROM CLIPBOARD
					else if setupnew = m
						ToolTip, ENTER YOR MACRO (PRESS ESC TO CANCEL)`n  - PRESS ENTER TO FINISH`n  - PRESS ALT & E TO ADD NEW LINE`n  - PRESS ALT+S BEFORE FINISH TO ENCRYPT`n  - PRESS ALT+V TO PASTE`n  - PRESS ALT+I TO INSERT A FILE OR FOLDER`n`nTO RECORD A MACRO PRESS ALT+R`n  - (FINISH RECORDING WITH KEY PAUSE)`n`nTO PAUSE PROGRAMM USE CAPSLOCK & F11
				}	
			}
			else if count = 1
			{
				ToolTip, PLEASE ENTER YOUR KEYWORD AND PRESS ENTER`n`nCANCEL WITH ESC`nALT+V = PASTE FROM CLIPBOARD
			}
			else if count = 2
			{
				ToolTip, ENTER DESCRIPTION AND PRESS ENTER`n`nCANCEL WITH ESC`nALT+V = PASTE FROM CLIPBOARD
			}
			else if count = 3
			{
					If setupnew = i
					ToolTip, ENTER WEBSITE AND PRESS ENTER`n`nCANCEL WITH ESC`nALT+V = PASTE FROM CLIPBOARD
					else if setupnew = p
					{
							ToolTip,
							FileSelectFile, setupprogramm, , , , *.exe
							MsgBox % setupprogramm
							/*
							If (RegExMatch(setupprogramm, "\.\w$") = 0)
								break
							else
							{
								StringSplit, setupprogramm, setupprogramm, %A_Space%
								setupprogramm := setupprogramm1 . programseparator . setupprogramm2
							}	
							*/																				
							break
					}
					else if setupnew = o
					{
							FileSelectFolder, setupprogramm
							break
					}
					else if setupnew = m
					{
						Encryption =
						ToolTip, ENTER YOR MACRO (PRESS ESC TO CANCEL)`n  - PRESS ALT & E TO ADD NEW LINE`n  - PRESS ENTER TO FINISH`n  - PRESS ALT+S BEFORE FINISH TO ENCRYPT`n  - PRESS ALT+V TO PASTE`n  - PRESS ALT+I TO INSERT A FILE OR FOLDER`n  `nTO RECORD A MACRO PRESS ALT+R`n  - (FINISH RECORDING WITH KEY PAUSE)
					}
					
			}
			else
			{
					ToolTip, !!!PRESS ENTER TO DELETE MACRO!!!`nANY OTHER KEY TO CANCEL
					Input, deletevar, L1, {ENTER}{ESC}{LALT}{RALT}{LCONTROL}{RCONTROL}{LSHIFT}{RSHIFT}{UP}{DOWN}{LEFT}{RIGHT}
					ToolTip,
					If Errorlevel = EndKey:Enter
					{
						IniDelete, %config%, %DEFAULT%, %setupkey%
						%setupkey%0 =
						%setupkey%1 =
						%setupkey%2 =
						%setupkey%3 =
						%setupkey% =
						GoSub, restartini
					}
					Exit
			}
			Input, setupsave, %inputoptions%, {ENTER}{ESC}{BS}{LAlt}
			If Errorlevel = Max
			{
					AutoTrim, Off
					setupparamv = %setupparamv%%setupsave%
					AutoTrim, On
					setupparam = 1
			}
			else if Errorlevel = EndKey:Escape
			{
					ToolTip,
					Exit
			}
			else if (Errorlevel = "EndKey:LAlt" or Errorlevel = "EndKey:RAlt")
			{
				Input, setuppaste, L1, {ESC}
				If Errorlevel = EndKey:Escape
				continue
				else if setuppaste = v
				{ 
						If setupparamvleer = 1
						{
							setupparamv = %setupparamv%%A_Space%%clipboard%
							setupparamvleer =
						}
						else
						{
							setupparamv = %setupparamv%%clipboard%
						}
					setupparam = 1
				}
				else if setuppaste = e
				{
					If setupparamvleer = 1
					{
						setupparamv .= A_Space . macroseparator
						setupparamvleer =
					}
					else
					{
						setupparamv .= macroseparator
					}
					setupparam = 1
				}
				else if setuppaste = s
				{
					If count = 3
					{
								encryptmakrokeys = %setupparamv%
								Encryptmakro(encryptmakrokeys, config)
								setupprogramm = %encryptmakrokeys%
								break
					}
				}
				else if setuppaste = r
				{
					GoSub, Record
					setupparam = 1
					continue
				}
				else if setuppaste = i
				{
					MsgBox, 4, %SCRIPTNAME_VAR% FILE/FOLDER, PLEASE SELECT`n`n     YES TO SELECT A FILE`n     NO TO SELECT A FOLDER
					IfMsgBox Yes
						FileSelectFile, tempfileinput,,, %SCRIPTNAME_VAR% SELECT A FILE
					else 
						FileSelectFolder, tempfileinput,,3, %SCRIPTNAME_VAR% SELECT A FOLDER
					setupparamv .= tempfileinput
					tempfileinput := ""
				}
			}
			else if Errorlevel = EndKey:Backspace
			{
					If setupparamvleer = 1
					{
						setupparamvleer =
					}
					else
					{
						StringTrimRight, setupparamv, setupparamv, 1
					}
			}
			else if Errorlevel = EndKey:Enter
			{
					If setupparamv =
					{
						If (count = "1" and setupsave = "")
						{
							ToolTip,
							Exit
						}
						else if count = 2
						{
							setupname = Default
						}
						count++
						continue
					}
					else if count = 1
					{
						setupkey = %setupparamv%
						setupparamv =
					}
					else if count = 2
					{
						setupname = %setupparamv%
						setupparamv =
					}
					else if count = 3
					{
						If setupnew = i
							setupprogramm = webbrowserfile . programseparator . setupparamv
						else if setupnew = m
						{
							setupprogramm = %setupparamv%
						}
						break
					}
					Count++
					setupparam =
			}
	}
	If (setupname = "" and setupprogramm = "" and setupkey = "")
	Goto, Cleareingabe
	ToolTip, PRESS ENTER TO SAVE OR ANY OTHER KEY TO CANCEL`n`nKEYWORD:`t%setupkey%`nDESCRIPTION:`t%setupname%`nPROGRAMM:`t%setupprogramm%
	Input, setupabbrechen, L1, {ENTER}{ESC}
	ToolTip,
	If Errorlevel = EndKey:Enter
	{
		RegExMatch(setupkey, "^\w+$", setupkeycheck)
		If (setupkey != setupkeycheck) ;is not alnum
		{
			MsgBox, 0, NOT ALLOWED, ONLY ALPHANUMERIC CHARACTERS ARE ALLOWED
			Goto, Cleareingabe
		}
		IniWrite, %setupname%%programseparator%%setupprogramm%, %config%, %DEFAULT%, %setupkey%
		Goto, restartini
	}
	else if Errorlevel = EndKey:Escape
	{
		Goto, Cleareingabe
	}
	Return
}

Restoreini:
{
		FileCopy, %config%, %SCRIPTNAME_VAR%configbakup.bak, 1
		ToolTip,
		FileSelectFile, savedirfile, , , Restore INI - Select File, BACKUP AND INI FILES (*.ini; *.bak)
		;MsgBox, %savedirfile%
		FileRead, savedirfilecontent, %savedirfile%
		;MsgBox, %savedirfile%
		IfNotInString, savedirfilecontent, F93DHH98E08776AC
		{
			MsgBox, 0, INCORRECT FILE, SELECTED FILE IS NOT VALID
			Return
		}
		MsgBox, 4, APPLY NEW CONFIG FILE, PRESS YES IF YOU WANT TO REPLACE ALL YOUR EXISTING MACROS WITH IMPORTED FILE
		IfMsgBox No
			Return
		IniRead, key, %config%, DEFAULT, F93DHH98E08776AC, ERROR
		;MsgBox % key
		FileDelete, %config%
		;MsgBox, Deleted
		FileCopy, %savedirfile%, config.ini, 1
		;MsgBox, key: %key% to write
		IniWrite, %key%, %config%, DEFAULT, F93DHH98E08776AC
		Reload
	Return
}












;____________________________________
;#Include mouse.txt
1Include_Mouse:
Mousespeed:
{
	SetFormat, FLOAT, 0.1
	StringSplit, mousespeed, A_ThisHotkey, &, %A_Space% ~
	If mousespeed1 = RIGHT
		standardspeed += 1
	If mousespeed1 = LEFT
		standardspeed -= 1
	If mousespeed1 = DOWN
		accellerationspeed -= 0.1
	If mousespeed1 = UP
	accellerationspeed += 0.1
	ToolTip, MOUSESPEED: %standardspeed%`nACCELERATION: %accellerationspeed%,,,20
	SetFormat, FLOAT, 0.16
	SetTimer, RemoveToolTip, 800
	Return
}

Mouse:
{
	speedtoadjust = %standardspeed%
	accelleration = %accellerationspeed%
	StringSplit, mousedirection, A_ThisHotkey, &, %A_Space% ~
	xcurrposmouse = 0
	ycurrposmouse = 0
	Loop
	{
		If ((mousedirection1 = "LEFT" and mousedirection2 = "RIGHT") or (mousedirection1 = "RIGHT" and mousedirection2 = "LEFT") or (mousedirection1 = "DOWN" and mousedirection2 = "UP") or (mousedirection1 = "UP" and mousedirection2 = "DOWN"))
		{
			If mousedirection1 = LEFT
				xcurrposmouse += %speedtoadjust%
			else if mousedirection1 = UP
				ycurrposmouse += %speedtoadjust%
			else if mousedirection1 = RIGHT
				xcurrposmouse -= %speedtoadjust%
			else if mousedirection1 = DOWN
				ycurrposmouse -= %speedtoadjust%				
		}
		else
		{
			If (mousedirection2 = "LEFT" or mousedirection1 = "LEFT")
			xcurrposmouse -= %speedtoadjust%
			If (mousedirection2 = "RIGHT" or mousedirection1 = "RIGHT")
			xcurrposmouse += %speedtoadjust%
			If (mousedirection2 = "UP" or mousedirection1 = "UP")
			ycurrposmouse -= %speedtoadjust%
			If (mousedirection2 = "DOWN" or mousedirection1 = "DOWN")
			ycurrposmouse += %speedtoadjust%
		}
		KeyWait, %mousedirection2%, T0.001
		If Errorlevel = 0
		break
		MouseMove, %xcurrposmouse%, %ycurrposmouse%, , R
		speedtoadjust *=%accelleration%
		EnvAdd, accelleration, 0.03
		IfLess, accelleration, 1.5, Sleep, 100
	}
	Return
}











;________________________________
;#Include gui.profilemanager.txt
1Include_gui_profilemanager:
Changeprofile:
{	
	ToolTip,,,,20
	IfWinExist, %SCRIPTNAME_VAR% CHANGE PROFILE
	{
		WinActivate, %SCRIPTNAME_VAR% CHANGE PROFILE
		Return
	}
	SetTimer, RemoveToolTip, Off
	;allprofiles =
	StringSplit, allprofiles, allprofiles, |
	IniRead, defaultprofile, %config%, DEFAULT, defaultprofile, ERROR
	IfWinNotActive, %SCRIPTNAME_VAR%
	{
		ToolTip, CURRENTLY LOADED:   %defaultprofile%`n`nPRESS NUMBER TO APPLY`nESC TO EXIT`n`n1: %allprofiles1%`n2: %allprofiles2%`n3: %allprofiles3%`n4: %allprofiles4%`n5: %allprofiles5%`n6: %allprofiles6%`n7: %allprofiles7%`n8: %allprofiles8%`n9: %allprofiles9%,,,20
		KeyWait, CAPSLOCK
		SetCapsLockState, Off
		Input, profiletoapply, L1 T1.5, {ESC}{ENTER}
		ToolTip,,,,20
		;MsgBox % GetKeyState("CAPSLOCK", "P")
		If Errorlevel = Max
		{
			If profiletoapply is digit
			 	{
			 		;MsgBox, %allprofiles%
			 		Gui, Destroy
			 		choosenprofile := allprofiles%profiletoapply%
					If choosenprofile =
					{
						MsgBox, NO PROFILE SELECTED
						Return
					}
					IfNotInString, allprofiles, %choosenprofile%|
					{
						MsgBox, PROFILE DOES NOT EXIST
						Return
					}
					IniWrite, %choosenprofile%, %config%, DEFAULT, defaultprofile
					Loop, Read, %config%
					{
						linevalue := A_LoopReadLine
						;FileReadLine, linevalue, %config%, %A_Index%
						;If Errorlevel
						;	break
						StringLeft, linevaluefirst, linevalue, 1
						Stringsplit, linevalue, linevalue, `=, %A_Space%
						If (linevaluefirst = "[" or linevalue1 = "F93DHH98E08776AC" or linevalue = "" or linevalue1 = "defaultprofile")
							continue
						;MsgBox % %linevalue1%1
						SetEnv, %linevalue1%,
						IfNotEqual, %linevalue1%1,
							SetEnv, %linevalue1%1,
						IfNotEqual, %linevalue1%2,
							SetEnv, %linevalue1%2,
						IfNotEqual, %linevalue1%3,
							SetEnv, %linevalue1%3,
						IfNotEqual, %linevalue1%4,
							SetEnv, %linevalue1%4,
					}
					WinClose, %SCRIPTNAME_VAR% MACRO MANAGEMENT, 
					;Gui, 3:Show
					;Gui, 3:Destroy
					GoSub, Restartini
					ToolTip, SELECTED: %choosenprofile%,,,20
					SetTimer, RemoveToolTip, 800
				}
				Return
		}
	}
	Gui, 1:Destroy
	Gui, 3:Default
	Gui, 3:Add, Text, , CurrentProfile:    %DEFAULT%`n
	Gui, 3:Add, Edit, , ENTER NEW PROFILE
	Gui, 3:Add, Button, x+1 Default gNewprofile, &CREATE
	Gui, 3:Add, Button, x+1 gDeleteprofile, &DELETE
	Gui, 3:Add, ListView, xs r15 w250 Count50 NoSortHdr +ReadOnly AltSubmit Grid Multi gProfilechange, CLICK TO CHOOSE PROFILE
	Loop %allprofiles0%
	{
		If allprofiles%A_Index% =
		break
		LV_ADD("", allprofiles%A_Index%)
	}
	Gui, 3:Show,,%SCRIPTNAME_VAR% CHANGE PROFILE
	;WinSetTitle, %SCRIPTNAME_VAR%,, %SCRIPTNAME_VAR% CHANGE PROFILE
	;WinWaitClose, %SCRIPTNAME_VAR% CHANGE PROFILE,,
	Return
}

Deleteprofile:
{
	MsgBox, 4, DELETE PROFILE, ALL KEYS/MACROS OF THIS PROFILE(IF ANY EXISTING)`nWILL BE APPLIED TO PREVIOUS PROFILE, 5
	IfMsgBox Yes
	{
	}
	else
	{
		Return
	}
	GuiControlGet, deleteprofile, , Edit1
	If (deleteprofile = "" or deleteprofile = DEFAULT)
		{
			MsgBox, CANNOT DELETE %deleteprofile%`nCHECK IF IT IS NOT DEFAULT OR EMPTY
			Return
		}
	FileCopy, %config%, %config%.bak, 1
	FileRead, filecontent, %config%
	StringReplace, filecontent, filecontent, `n`n, `n, All
	StringReplace, filecontent, filecontent, [%deleteprofile%], , UseErrorLevel 
	If Errorlevel = 0
	{
		MsgBox, PROFILE DOES NOT EXIST
		Return
	}
	trytodeletefileagain:
	FileDelete, %config%
	If Errorlevel = 1
	{
		MsgBox, COULD NOT DELETE FILE`n`nCLOSE ALL PROGRAMMS THAT USE FILE: %config%
		Goto, trytodeletefileagain
	}
	trytoappendfileagain:
	FileAppend, %filecontent%, %config%
	If Errorlevel = 1
	{
		MsgBox, COULD NOT CREATE FILE
		Goto, trytoappendfileagain
	}
	Gui, 1:Destroy
	Gui, 3:Destroy
	GoSub, Restartini
	Return
}

Newprofile:
{
	GuiControlGet, newprofile, , Edit1
	If newprofile =
		Return
	IfInString, newprofile, %A_Space%
		Return
	If newprofile is alnum
	{
		;FileRead, filecontent, %config%
		IfNotInString, allprofiles, %newprofile%.
		{
			Gui, 1:Destroy
			FileAppend, `n[%newprofile%], %config%
			allprofiles = %allprofiles%%newprofile%|
			LV_ADD("", newprofile)
		}
	}
	Return
}

Profilechange:
{
	;MsgBox, event: %A_GuiEvent% info: %A_EventInfo% error: %Errorlevel%
	If A_GuiEvent = I
	{
		;MsgBox, event: %A_GuiEvent% info: %A_EventInfo% error: %Errorlevel%
		IfInString, Errorlevel, S
		{
			LV_GetText(choosenprofile, A_EventInfo)
			;FileRead, filecontent, %config%
			;MsgBox, %choosenprofile% `n%allprofiles%
			IfNotInString, allprofiles, %choosenprofile%|
			{
				MsgBox, PROFILE DOES NOT EXIST
				Return
			}
			IniWrite, %choosenprofile%, %config%, DEFAULT, defaultprofile
			Loop, Read, %config%
			{
				linevalue := A_LoopReadLine
				;FileReadLine, linevalue, %config%, %A_Index%
				;If Errorlevel
				;	break
				StringLeft, linevaluefirst, linevalue, 1
				Stringsplit, linevalue, linevalue, `=, %A_Space%
				If (linevaluefirst = "[" or linevalue1 = "F93DHH98E08776AC" or linevalue = "" or linevalue1 = "defaultprofile")
					continue
				;MsgBox % %linevalue1%1
				SetEnv, %linevalue1%,
				IfNotEqual, %linevalue1%1,
					SetEnv, %linevalue1%1,
				IfNotEqual, %linevalue1%2,
					SetEnv, %linevalue1%2,
				IfNotEqual, %linevalue1%3,
					SetEnv, %linevalue1%3,
				IfNotEqual, %linevalue1%4,
					SetEnv, %linevalue1%4,
			}
			;WinClose, %SCRIPTNAME_VAR% MAKROVERWALTUNG, 
			Gui, 3:Destroy
			GoSub, Restartini
			ToolTip, SELECTED: %choosenprofile%,,,20
			SetTimer, RemoveToolTip, 800
		}
	}
	Return
}

3GuiClose:
	Gui, 3:Destroy
	GoSub, Restartini
	Gui, Default
Return

3GuiEscape:
	Gui, 3:Destroy
	GoSub, Restartini
	Gui, Default
Return











;____________________________________
;#Include qwerty.txt
1Include_qwerty:
DoHotkey:
{
  StringRight ThisKey, A_ThisHotkey, 1
  i1 := InStr(original, ThisKey)
  i2 := InStr(mirrored, ThisKey)
  If (i1+i2 = 0) {
    MirrorKey := ThisKey
  } Else If (i1 > 0) {
    MirrorKey := SubStr(mirrored, i1, 1)
  } Else {
    MirrorKey := SubStr(original, i2, 1)
  }
 
  Modifiers := ""
  If (GetKeyState("LWin") || GetKeyState("RWin")) {
    Modifiers .= "#"
  }
  If (GetKeyState("Control")) {
    Modifiers .= "^"
  }
  If (GetKeyState("Alt")) {
    Modifiers .= "!"
  }
  If (GetKeyState("Shift") + GetKeyState("CapsLock", "T") = 1) {
    ; only add if Shift is held OR CapsLock is on (XOR) (both held down would result in value of 2)
    Modifiers .= "+"
  }
  Send %Modifiers%{%MirrorKey%}
return
}


QWERTYonoff:
{
	If qwertyonoff = 1
	{
		Loop % StrLen(original)
		{
		  onehandc1 := SubStr(original, A_Index, 1)
		  onehandc2 := SubStr(mirrored, A_Index, 1)
		  Hotkey Space & %onehandc1%, ,Off
		  Hotkey Space & %onehandc2%, ,Off
		}
		Hotkey, Space, Off
		Hotkey, Space & CapsLock, Off
		Hotkey, Space & Tab, Off
		Hotkey, +Space, Off
		qwertyonoff =
		ToolTip, QWERTY KEYBOARD IS OFF,,,20
		SetTimer, RemoveToolTip, 2000
	}
	else
	{
		Loop % StrLen(original)
		{
		  onehandc1 := SubStr(original, A_Index, 1)
		  onehandc2 := SubStr(mirrored, A_Index, 1)
		  Hotkey Space & %onehandc1%, On
		  Hotkey Space & %onehandc2%, On
		}
		Hotkey, Space & CapsLock, On
		Hotkey, Space & Tab, On
		Hotkey, Space, On
		Hotkey, +Space, On
		qwertyonoff = 1
		ToolTip, QWERTY KEYBOARD IS ON,,,20
		SetTimer, RemoveToolTip, 2000
	}
Return
}











;_________________________________
;#Include restartini.txt
1Include_restartini:
RESTARTINI:
{
	;MsgBox % autostarton
	Suspend, On
	allprofiles =	
	hotkeyslist =
	Loop %hotkeykeys0%
	{
		A_KeyIndex := hotkeykeys%A_Index%
		capslockvar%A_KeyIndex% =
		scrolllockvar%A_KeyIndex% =
		numlockvar%A_KeyIndex% =
	}
	Loop %hotkeys0%
	{
		A_KeyIndex := hotkeys%A_Index%
		hotkeyvar%A_KeyIndex% =
	}
	Loop, Read, %config%
	{
		linevalue := A_LoopReadLine
		If A_LoopReadLine =
			continue
		StringLeft, linevaluefirst, linevalue, 1
		Stringsplit, linevalue, linevalue, `=, %A_Space%
		If linevalue1 = setwebbrowser
		{
			StringSplit, changewebbrowser, linevalue, %programseparator%
			webbrowserfile = %changewebbrowser2%
		}
		If linevalue1 = setmouse
		{
			StringSplit, changewebbrowser, linevalue, %programseparator%
			StringSplit, setmousesettings, changewebbrowser2, |
			standardspeed = %setmousesettings1%
			accellerationspeed = %setmousesettings2%
		}
		If linevalue1 = setwinwatcher
		{
			StringSplit, changewebbrowser, linevalue, %programseparator%
			changewebbrowser2 *= 1000
			winwatcherspeed = %changewebbrowser2%
		}
		If linevalue1 = setdebugger
		{
			StringSplit, changedebugger, linevalue, %programseparator%
			debuggerison = %changedebugger2%
			debuggerslowdown = %changedebugger3%
		}
		If linevalue1 = setautostart
		{
			StringSplit, changeautostart, linevalue, %programseparator%
			autostarton = %changeautostart2%
		}
		If (linevaluefirst = "[")
		{
			StringTrimLeft, linevalue, linevalue, 1
			StringTrimRight, linevalue, linevalue, 1
			;MsgBox % linevalue
			allprofiles = %allprofiles%%linevalue%|
			currentprofile = %linevalue%
			continue
		}
		If linevalue1 = defaultprofile
		{
			DEFAULT = %linevalue2%
			continue
		}
		IfNotEqual, currentprofile, %DEFAULT%
		continue
		If (linevaluefirst = "[" or linevalue1 = "F93DHH98E08776AC" or linevalue1 = "" or linevalue1 = "defaultprofile" or linevalue1 = "setautostart" or linevalue1 = "setdebugger" or linevalue1 = "setwinwatcher" or linevalue1 = "setmouse" or linevalue1 = "setwebbrowser")
		continue
		key := linevalue1
		Loop 4
		{
			key%A_Index% =
		}
		IniRead, %key%, %config%, %DEFAULT%, %key%, %key%
		;VarSetCapacity(%key%2, 5120)
		Stringsplit, %key%, %key%, %programseparator%, %A_Space%%A_Tab%
		autostartvar := %key%
		checkifvarisautostart = %autostartvar%1
		StringLower, checkifvarisautostart, checkifvarisautostart
		StringReplace, checkifvarisautostart, checkifvarisautostart, %A_Space%,
		If scriptsfirstrun = 
		{
			If autostarton = ASK
			{	
				IfInString, checkifvarisautostart, autostart
				{
					MsgBox, 262148, AUTOSTART, , 3
					IfMsgBox Yes
					{
						autostarton = ON
						autostartparameter = %autostartparameter%%key%|
					}
					else
					{
						autostarton = Off
					}
					autostartvar =
				}
			}
			else if autostarton = ON
			{
				IfInString, checkifvarisautostart, autostart
				{
					autostartparameter = %autostartparameter%%key%|
					autostartvar =
				}
			}
		}
		IfInString, checkifvarisautostart, capslock
		{
			StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "capslock", CaseSensitive = false)+8, 1
			IfInString, hotkeykeys, %favnumber%
			capslockvar%favnumber% = %key%
		}
		IfInString, checkifvarisautostart, scrolllock
		{
			StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "scrolllock", CaseSensitive = false)+10, 1
			IfInString, hotkeykeys, %favnumber%
			scrolllockvar%favnumber% = %key%
		}
		IfInString, checkifvarisautostart, numlock
		{
			StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "numlock", CaseSensitive = false)+7, 1
			IfInString, hotkeykeys, %favnumber%
			numlockvar%favnumber% = %key%
		}
		IfInString, checkifvarisautostart, hotkey
		{
			StringMid, favnumber2, checkifvarisautostart, InStr(checkifvarisautostart, "hotkey", CaseSensitive = false)+6, 2
			IfInString, hotkeys, %favnumber2%
			{
				hotkeyvar%favnumber2% = %key%
				hotkeyslist = %hotkeyslist%%favnumber2%.
			}
		}
		linevalue1 =
	}
	Loop %hotkeykeys0%
	{
		capslockhotkey := hotkeykeys%A_Index%
		Hotkey, CAPSLOCK & %capslockhotkey%, RunCapsLock
	}
	Loop %hotkeykeys0%
	{
		scrolllockhotkey := hotkeykeys%A_Index%
		Hotkey, SCROLLLOCK & %scrolllockhotkey%, RunScrollLock
	}
	Loop %hotkeykeys0%
	{
		numlockhotkey := hotkeykeys%A_Index%
		Hotkey, NUMLOCK & %numlockhotkey%, RunNumLock
	}
	StringSplit, hotkeyslist, hotkeyslist, `.
	hotkeyslist0 -= 1
	Loop %hotkeyslist0%
	{
		StringLeft, hotkeya, hotkeyslist%A_Index%, 1
		StringRight, hotkeyb, hotkeyslist%A_Index%, 1
		Hotkey, %hotkeya% & %hotkeyb%, RunHotkey, Off
	}
	StringSplit, autostartparameter, autostartparameter, |
	autostartparameter0--
	Suspend, Off
	If autostartparameter > 0
	ToolTip
	If scriptfirstrun = 
	{
		Loop %autostartparameter0%
		{
			out := autostartparameter%A_Index%
			RunVar()
		}
	}	
	autostarton = OFF
	autostartparameter =
	scriptsfirstrun = NO
	EmptyMem()
	Return
}















;_______________________________
;#Include runhotkeys.txt
1Include_runhotkeys:
RunCapsLock:
{
	ToolTip,,,,20
	runningcapslock++
	StringRight, hotkeyvartorun, A_ThisHotkey, 1
	If capslockvar%hotkeyvartorun% =
	{
		runningcapslock--
		Return
	}
	If runningcapslock > 1
	{
		runningcapslock--
		Return
	}
	KeyWait, %hotkeyvartorun%
	KeyWait, CAPSLOCK
	Send, {%hotkeyvartorun% UP}
	SetCapsLockState, Off
	out := capslockvar%hotkeyvartorun%
	runningcapslock =
	hotkeyvartorun =
	RunVar()
	Return
}

RunScrollLock:
{
	ToolTip,,,,20
	runningscrolllock++
	StringRight, hotkeyvartorun, A_ThisHotkey, 1
	If scrolllockvar%hotkeyvartorun% =
	{
		runningscrolllock--
		Return
	}
	If runningscrolllock > 1
	{
		runningscrolllock--
		Return
	}
	KeyWait, %hotkeyvartorun%
	KeyWait, SCROLLLOCK
	Send, {%hotkeyvartorun% UP}
	SetScrollLockState, Off
	out := scrolllockvar%hotkeyvartorun%
	runningscrolllock =
	hotkeyvartorun =
	RunVar()
	Return
}

RunNumLock:
{
	ToolTip,,,,20
	runningnumlock++
	StringRight, hotkeyvartorun, A_ThisHotkey, 1
	KeyWait, %hotkeyvartorun2%
	KeyWait, NUMLOCK
	Send, {%hotkeyvartorun2% UP}
	SetNumLockState, On
	IfInString, A_ThisHotkey, NUMPAD
	{
		StringSplit, hotkeyvartorunreplace, A_ThisHotkey, &, %A_Space%
		If hotkeyvartorunreplace2 = NUMPADINS
			hotkeyvartorun = 0
		If hotkeyvartorunreplace2 = NUMPADEND
			hotkeyvartorun = 1
		If hotkeyvartorunreplace2 = NUMPADDOWN
			hotkeyvartorun = 2
		If hotkeyvartorunreplace2 = NUMPADPGDN
			hotkeyvartorun = 3
		If hotkeyvartorunreplace2 = NUMPADLEFT
			hotkeyvartorun = 4
		If hotkeyvartorunreplace2 = NUMPADCLEAR
			hotkeyvartorun = 5
		If hotkeyvartorunreplace2 = NUMPADRIGHT
			hotkeyvartorun = 6
		If hotkeyvartorunreplace2 = NUMPADHOME
			hotkeyvartorun = 7
		If hotkeyvartorunreplace2 = NUMPADUP
			hotkeyvartorun = 8
		If hotkeyvartorunreplace2 = NUMPADPGUP
			hotkeyvartorun = 9
		If hotkeyvartorunreplace2 = NUMPADDEL
			hotkeyvartorun = d
		If hotkeyvartorunreplace2 = NUMPADDIV
			hotkeyvartorun = v
		If hotkeyvartorunreplace2 = NUMPADMULT
			hotkeyvartorun = m
		If hotkeyvartorunreplace2 = NUMPADADD
			hotkeyvartorun = a
		If hotkeyvartorunreplace2 = NUMPADSUB
			hotkeyvartorun = s
		If hotkeyvartorunreplace2 = NUMPADENTER
			hotkeyvartorun = e
		;MsgBox, %hotkeyvartorun%
	}
	If numlockvar%hotkeyvartorun% =
	{
		runningnumlock--
		Return
	}
	If runningnumlock > 1
	{
		runningnumlock--
		Return
	}
	out := numlockvar%hotkeyvartorun%
	runningnumlock =
	hotkeyvartorun =
	RunVar()
	Return
}

RunHotkey:
{ 
	ToolTip,,,,20
	runninghotkey++
	StringSplit, hotkeytorun, A_ThisHotkey, &, %A_Space%
	StringRight, hotkeyvartorun1, hotkeytorun1, 1
	StringRight, hotkeyvartorun2, hotkeytorun2, 1
	hotkeytorun = %hotkeyvartorun1%%hotkeyvartorun2%
	If hotkeyvar%hotkeytorun% =
	{
		runninghotkey--
		Return
	}
	If runninghotkey > 1
	{
		runninghotkey--
		Return
	}
	KeyWait, %hotkeytorun2%
	KeyWait, %hotkeytorun1%
	Send, {%hotkeytorun2% UP}{%hotkeytorun1% UP}
	;ToolTip % A_ThisHotkey, 0, 60, 4
	out := hotkeyvar%hotkeytorun%
	runninghotkey =
	hotkeytorun =
	RunVar()
	Return
}










;____________________________________________
;#Include maingui.txt
1Include_maingui:
Eingabe_Starten:
{
	KeyWait, CAPSLOCK
	SetCapsLockState, Off
	SetTimer, RemoveToolTip, Off
	Suspend, On
	Loop
	{
							outfunc =
							;accvarstart =   ;`n----`n
							If out =
									ToolTip % outleertooltip, , , 20
							;test := GetKeyState("CAPSLOCK", "T")
							Input, output, L1, {ENTER}{LALT}{ESC}{BS}{SPACE}{F4}
							If Errorlevel = Max
							{
								If outputspace = 
								out =%out%%output%				
							}
							else if Errorlevel = EndKey:F4
							{
								saved += 1
								out := savedout%saved%
								If savedout%saved% =
								saved =
							}
							else if Errorlevel = EndKey:Enter
							{
								saved =
								ToolTip,,,,20
								If out =
								{
									BlockInput, Off
									Suspend, Off
									Return
								}
								If out = %savedout1%
								{
								}
								else
								{
									countsave = 30
									countsave2 = 29
									Loop 29
									{
										savedout%countsave% := savedout%countsave2%
										countsave -= 1
										countsave2 -= 1
									}
									savedout1 = %out%
								}
									If out =
									{
										BlockInput, Off
										Suspend, Off
										Return
									}
									Suspend, Off
									RunVar()
									Return
							}
							else if Errorlevel = EndKey:Backspace
							{
									Stringlen, elength, out
									If outputspace = 1
									{
												outputspace =
												ToolTip, %out%%accvarstart%%accvarend%,,,20
												continue
									}
									Stringright, eoutend, out, 3
									StringGetPos, eleerpos, eoutend, %A_Space%
									If eleerpos = 1
									{
												elength -= 2
												StringLeft, out, out, %elength%
												ToolTip, %out%%A_Space%%accvarstart%%accvarend%,,,20
												outputspace = 1
												continue
									}
									else
									{
										StringTrimRight, out, out, 1
									}
							}
							else if Errorlevel = EndKey:Escape
							{
										ToolTip, CANCEL...,,,20
										Sleep, 200
										Gosub, Cleareingabe
										Suspend, Off
										Return
							}
							else if Errorlevel = EndKey:Space
							{
									outputspace = 1
									ToolTip, %out%%A_Space%%accvarstart%%accvarend%,,,20
									continue
							}
							else if Errorlevel = EndKey:LAlt
							{
														Loop
														{
															Input, outfunc, L1 T1 M
															If Errorlevel = Timeout
															{
																GetKeyState, altispressed, LALT, P
																If (altispressed = "D" and outfunc = "") 
																	continue
																else
																	break
															}
															else
																break
														}
														If outfunc = 
																continue
														else if outfunc = v
														{
																If outputspace = 1
																{
																		out = %out%%A_Space%%clipboard%
																		outputspace =
																}
																else
																{
																	out = %out%%clipboard%
																}
																ToolTip, %out%,,,20
																continue
														}
														else if outfunc = a
														{
															ExitApp
														}
														else if outfunc = m
														{
																If moreoptions = yes
																{
																	outleertooltip := eingabestarttooltip
																	moreoptions = 
																}
																else
																{
																	outleertooltip = %SCRIPTNAME_VAR% IS READY. TYPE TO START`n--------------------------------------------------`n - ESC = CANCEL`n - ENTER = - WEBSEITE(no www..com)`n`t      - `? TRANSLATE`n`t      - `. GOOGLE SEARCH`n`t      - `- EBAY SEARCH`n`t      - : HARDWAREECKE SEARCH`n`t      - `=5+5 `= CALCULATE`n`t      - e.g.: .google`n - ALT+X = FOLDER and FILE SEARCH(CAPSLOCK+SHIFT)`n - ALT+E = SETTINGS(CAPSLOCK+F8)`n - ALT+A = %SCRIPTNAME_VAR% EXIT`n - ALT+N = NEW PASSWORD`n - ALT+H = HIDE WINDOW(CAPSLOCK+F4)`n - ALT+U = UNHIDE WINDOW(CAPSLOCK+F3)`n - ALT+Q = HELP(CAPSLOCK+F9)`n - ALT+C = MACRO MANAGEMENT(CAPSLOCK+F5 überall)`n - ALT+V = PASTE`n - ALT+Y = QWERTY KEYBOARD ON/OFF(type with one hand)`n - ALT+R oder CAPSLOCK+F12 = RESTART`n - CAPSLOCK+TAB = START ENTRY(or CTRL then SHIFT)`n - CAPSLOCK+F2 = REPEAT LAST COMMAND/PROGRAM`n - CAPSLOCK+F7 = SHOW ALL HOTKEYS ;`n - COPY/PASTE > CTRL+C then SHIFT then CTRL`n - ALT+C = PASTE CUSTOM
																	moreoptions = yes
																}
														}
														else if outfunc = c_aus
														{
																cliptooltip =
																count = 0
																Loop, 10
																{
																	StringLeft, cliptooltipvar, clipboard%count%, 50
																	StringReplace, cliptooltipvar, cliptooltipvar, `r`n, %A_Space%, All
																	cliptooltip = %cliptooltip%`n%count%: %cliptooltipvar%
																	count++
																}
																ToolTip, PRESS NUMBER TO PASTE(e.g. 1)`n TO COPY NEW TEXT`n after CTRL+C (Copy) press and hold CTRL`n%cliptooltip%,,,20
																Input, clpvar, L1, {ESC}
																If Errorlevel = Max
																{
																	If (clpvar = "0" or clpvar = "1" or clpvar = "2" or clpvar = "3" or clpvar = "4" or clpvar = "5" or clpvar = "6" or clpvar = "7" or clpvar = "8" or clpvar = "9")
																	{
																		Keywait, %clpvar%
																		ToolTip,,,,20
																		ClipSaved := ClipboardAll
																		;Msgbox % clipboard
																		Clipboard =
																		Clipboard := clipboard%clpvar%
																		ClipWait
																		Sleep, 10
																		;msgBox % clipboard
																		Send, ^v
																		Sleep, 10
																		Clipboard =
																		Clipboard := ClipSaved
																		ClipSaved =
																		Gosub, Cleareingabe
																		Suspend, Off
																		Return
																	}
																}
																else if Errorlevel = EndKey:Escape
																{
																	Gosub, Cleareingabe
																	Suspend, Off
																	Return
																}
														}
														else if outfunc = n
														{
															ToolTip,,,,20
															MsgBox, 291, NEW PASSWORD, !!!ARE YOU SURE?!!!`n!!!ALL SETTINGS AND MACROS WILL BE DELETED!!!, 30
															IfMsgBox YES
															{
																IniRead, filename, %config%, DEFAULT, F93DHH98E08776AC
																FileSetAttrib, -RHS, %filename%
																FileSetAttrib, -RHS, %config%
																FileDelete, %filename%
																Sleep, 50
																FileDelete, %config%
																Suspend, Off
																Goto, Neuespassword
															}
														}
														else if outfunc = x
																{
																	Suspend, Off
																	Goto, FileExplorer
																}
														else if outfunc = h
																{
																	Gosub, mwt_Minimize
																}
														else if outfunc = q
															{
																ToolTip,,,,20
																Suspend, Off
																Goto, HilfeBox
															}
														else if outfunc = u
																{
																	Gosub, mwt_UnMinimize
																}
														else if outfunc = c
																{
																	ToolTip,,,,20
																	Suspend, Off
																	Goto, Macrokeys
																}
														else if outfunc = e
														{
																ToolTip, ,,,20
																Suspend, Off
																GoTo, SETUPMACRO
														}
														else if outfunc = r
														{
															ToolTip,,,,20
															Suspend, Off
															GoTo, RestartProgram
														}
														else if outfunc = y
														{
															ToolTip,,,,20
															Suspend, Off
															GoTo, QWERTYonoff
														}
														continue
							}
							If outputspace = 1
							{
									outputspace =
									out = %out%%A_Space%%output%
							}
							ToolTip, %out%%accvarstart%%accvarend%,,,20
							IfNotInString, out, %A_Space%
							{
								RegExMatch(out, "^\w+$", out_checkifcanbevar)
								If (out = out_checkifcanbevar) ;If out is alnum
								{
										If %out%0 > 0
										{
											ToolTip % out A_TAB %out%1,,,20
										}
								}
							}				
	}
Suspend, Off
Goto, Cleareingabe
}

Cleareingabe:
{
 ToolTip,,,,20
 outleertooltip := eingabestarttooltip
 out =
 outputspace =
 saved =
Return
}









;_________________________________________
;#Include go.txt
1Include_go:
GO:
{
	StringSplit, ip, outrunvar, ., .
	StringLeft, first, outrunvar, 1
	StringRight, last, outrunvar, 1
	EnvGet, GoVariable, %outrunvar%
	StringLeft, ziel, outrunvar, 2
	StringRight, ziel1, ziel, 1
	StringLeft, vgoogle, outrunvar, 1
	StringTrimLeft, vgoogle2, outrunvar, 1
	StringLeft, iswebsite, outrunvar, 4
	If GoVariable =
	{
			If outrunvar = intranet
			{
				Run %webbrowserfile% http://intranet/
			}
			else if ziel1 = :
			{
				Run explorer /e`, %outrunvar%
			}
				else if vgoogle = .
			{
				Run %webbrowserfile% "http://www.google.de/search?hl=de&q=%vgoogle2%&meta="
			}
				else if vgoogle = ?
			{
				Run %webbrowserfile% "http://dict.leo.org/ende?lp=ende&lang=de&searchLoc=0&cmpType=relaxed&sectHdr=on&spellToler=on&search=%vgoogle2%&relink=on"
			}
				else if vgoogle = =
			{
				Goto, Calculate
			}	
				else if vgoogle = -
			{
					Run %webbrowserfile% "http://search-desc.ebay.de/search/search.dll?satitle=%vgoogle2%&fts=2"
			}
				else if vgoogle = :
			{
					Run %webbrowserfile% "http://www.hardwareecke.de/preisvergleich/index.php?site=search.jsp&name=%vgoogle2%&Submit=suchen&navCategoryID=11&priceRangeFrom=&priceRangeTo="
			}
				else if ziel = \\
			{
				Run explorer %outrunvar%
			}
				else if ip0 = 4
			{
				Run %webbrowserfile% %outrunvar%
			}
				else if iswebsite = http
			{
				Run %webbrowserfile% %outrunvar%
			}
				else
			{
				Run %webbrowserfile% "http://www.google.de/search?hl=de&q=%outrunvar%&btnI=Auf+gut+Glck&meta="
			}
	}
	else
	{
		StringLeft, iswebsite, GoVariable, 4
		If iswebsite = http
		{
			Run %webbrowserfile% %GoVariable%
		}
		else
		{
			Run explorer /e`, %GoVariable%
		}
	}
	Sleep, 300
	ToolTip,
	return
}











;____________________________________________
;#Include calculator.txt
1Include_calculator:
Calculate:
{
	delvalue = 0
	Loop, 20
	{
		ZAHL%delvalue% = 0
		ZEICHEN%delvalue% = 0
		delvalue += 1
	}
	StringSplit, ZAHL, vgoogle2, "+" "*" "/" "-",
	StringSplit, ZEICHEN, vgoogle2, , 1 2 3 4 5 6 7 8 9 0 `. `, `%
	
	;MsgBox, Zahlen: %ZAHL0%, Zeichen: %ZEICHEN0%
	
	n = 1
	c = 0
	lastpos = 0
	Save = 0
	
	If ZAHL1 contains `,
	StringReplace, ZAHL1, ZAHL1, `,, .,
	If ZAHL1 contains `%
	{
		StringTrimRight, percent1, ZAHL1, 1
		percent1 *= 0.01
		ZAHL1 := percent1
	}
	If ZAHL1 is not float
	ZAHL1 *= 1.00
	E := ZAHL1
	
	Loop, %ZEICHEN0%
	{
		
		n += 1
		c += 1
		
		If ZAHL%c% contains `,
		StringReplace, ZAHL%c%, ZAHL%c%, `,, .,
		
		If ZAHL%n% contains `,
		StringReplace, ZAHL%n%, ZAHL%n%, `,, .,
		
		If ZAHL%n% contains `%
		{
			StringTrimRight, percent, ZAHL%n%, 1
			percent *= 0.01
			ZAHL%n% := percent
		}	
		
		If ZAHL%c% is not float
		ZAHL%c% *= 1.00
		
		If ZAHL%n% is not float
		ZAHL%n% *= 1.00
		
		if ZEICHEN%n% contains *,/
		{
			if ZEICHEN%c% contains *,/
			{	
				if ZEICHEN%c% = *
				{
					E *= ZAHL%n%
				}
				else
				{	
					E /= ZAHL%n%
			  }
			}
			else
			{
				Save += %E%
				lastpos = %c%
				E := ZAHL%n%
				Continue
			}
		}	
		else if ZEICHEN%n% contains +,-
		{
			if ZEICHEN%c% = +
			{
				E += ZAHL%n%
			}
			else if ZEICHEN%c% = -
			{
				E -= ZAHL%n%
			}
			else if ZEICHEN%c% = *
			{
				E *= ZAHL%n%
				If ZEICHEN%lastpos% = + 
				E += %Save%
				else if ZEICHEN%lastpos% = -
				{
					E *= -1
				}
				E += %Save%
				Save = 0
			}
			else if ZEICHEN%c% = /
			{
				E /= ZAHL%n%
				If ZEICHEN%lastpos% = + 
				E += %Save%
				else if ZEICHEN%lastpos% = -
				{
					E *= -1
				}
				E += %Save%
				Save = 0
			}
		}
		If ZEICHEN%n% = 0
		{
		if ZEICHEN%c% = *
			{
				;MsgBox, %E%
				E *= ZAHL%n%
				;MsgBox, %E%
				If ZEICHEN%lastpos% = + 
				E += %Save%
				else if ZEICHEN%lastpos% = -
				{
					E *= -1
				}
				;E += %Save%
				Save = 0
			}
			else if ZEICHEN%c% = /
			{
				E /= ZAHL%n%
				If ZEICHEN%lastpos% = + 
				E += %Save%
				else if ZEICHEN%lastpos% = -
				{
					E := %Save% - %E%
				}
				Save = 0
			}
			else if ZEICHEN%c% = -
			{
			E -= ZAHL%n%
			}
			else if ZEICHEN%c% = +
			{
			E += ZAHL%n%
			}
		}
	}
	
	Loop
	{
		StringRight, zahlr, E, 1
		If zahlr = 0
		StringTrimRight, E, E, 1
		If zahlr = 0
		{
			continue
		}
		else
			{
				If zahlr = .
				StringTrimRight, E, E, 1
				break
			}
	}
	
	If E contains `.
	StringReplace, E, E, `., `,,
	MsgBox, %E%
	return
}








;____________________________________
;#Include fileexplorer.txt
1Include_fileexplorer:
FILEEXPLORER:
{
	KeyWait, SHIFT
	KeyWait, CAPSLOCK
	SetTimer, RemoveToolTip, Off
	count = 0
	explorervar =
	explorersearchagain =
	explorersearchsubfolders = 0
	explorersearchfile = 2
	explorerpressedspace =
	Loop
	{
		If explorervar =
		{
			ToolTip, FILE- AND FOLDER STARTER`n-------------------------`nENTER DRIVE & FOLDER`nPRESS F1 TO ENTER A VARIABLE,,,18
		}
		else
		{
			ToolTip, %explorervar%`n--------------------`nTAB = TAKE OVER PATH`nENTER = OPEN FILE/FOLDER`nF12(%explorersearchfile%): 0=FILES | 2=FOLDERS`nF11(%explorersearchsubfolders%): SEARCH SUBFOLDERS,,,18
		}
		If explorersearchagain =
		{
			Input, explorerstring, L1, {ENTER}{ESC}{BS}{F12}{F11}{F4}{F1}{Space}{DOWN}{LEFT}
		}
		else if explorersearchagain = 1
		{
			Errorlevel = Max
		}
		If Errorlevel = EndKey:Space
			explorerpressedspace = 1
		;MsgBox, %Errorlevel%
		If Errorlevel = Max
		{
			If explorervar = 
			{
				If explorerstring = \
				{
					explorervar = \\
				}
				else
				{
					explorervar = %explorerstring%`:`\
				}
			}
			else if explorersearchagain =
				{
					If explorerpressedspace =
					{
						explorervar = %explorervar%%explorerstring%
					}
					else
						{
							explorervar = %explorervar%%A_Space%%explorerstring%
							explorerpressedspace =
						}
				}
			explorerloopagain:
			explorersearchagain =
			ToolTip, SEARCHING....`nPLEASE WAIT...,,,18
			Loop, %explorervar%*.*, %explorersearchfile%, %explorersearchsubfolders%
			{
						If A_LoopFileSize > 0
						{
							ToolTip, %explorervar%`n--------------------`n%A_LoopFileLongPath%`n--------------------`nTAB = TAKE OVER PATH`nENTER = OPEN FILE/FOLDER`nF12(%explorersearchfile%): 0=FILES | 2=FOLDERS`nF11(%explorersearchsubfolders%): SEARCH IN SUBFOLDERS,,,18
						}
						else
						{
							ToolTip, %explorervar%`n--------------------`n%A_LoopFileLongPath%`\`n--------------------`nTAB = TAKE OVER PATH`nENTER = OPEN FILE/FOLDER`nF12(%explorersearchfile%): 0=FILES | 2=FOLDERS`nF11(%explorersearchsubfolders%): SEARCH SUBFOLDERS,,,18
						}
						Input, loopfileweiter, L1, {ENTER}{BS}{ESC}{TAB}{DOWN}{UP}{F12}{F11}{Space}{LEFT}
						If Errorlevel = EndKey:Tab
						{ 
								If A_LoopFileSize > 0
								{
									explorervar = %A_LoopFileLongPath%
								}
								else
								{
									explorervar = %A_LoopFileLongPath%\
								}
								explorersearchagain = 1
								break
						}
						else if Errorlevel = EndKey:Space
						{
							explorerpressedspace = 1
						}
						else if Errorlevel = EndKey:Down
						{
							ToolTip, SEARCHING....`nPLEASE WAIT...,,,18
							continue
						}
						else if Errorlevel = EndKey:Up
						{
							explorersearchagain = 1
							break
						}
						else if Errorlevel = EndKey:F11
						{
							If explorersearchsubfolders = 0
							{
								explorersearchsubfolders = 1
							}
							else
							{
								explorersearchsubfolders = 0
							}
							explorersearchagain = 1
							break
						}
						else if Errorlevel = EndKey:F12
						{
							If explorersearchfile = 0
								explorersearchfile = 2
							else
								{
									explorersearchfile = 0
								}
							;else if explorersearchfile = 1
								;{
									;explorersearchfile = 2
								;}
							explorersearchagain = 1	
							break
						}
						else if Errorlevel = EndKey:Left
						{
							StringTrimRight, explorervar, explorervar, 1
							explorersearchagain = 1	
							break
						}
						else if Errorlevel = EndKey:Backspace
						{
							StringRight, explorervarcutoff, ecplorervar, 1
							If explorervarcutoff = \
							{
								StringGetPos, explorervarcutoff, explorervar, \, R2, 1
							}
							else
							{
								StringGetPos, explorervarcutoff, explorervar, \, R, 1
							}
							explorervarcutoff += 1
							StringLeft, explorervar, explorervar, %explorervarcutoff%
							;Stringtrimright, explorervar, explorervar, 1
							If explorervar =
							{
								explorersearchagain =
							}
							else if explorervar = :\
								{
									explorervar =
									explorersearchagain =
								}
							else
							{
								explorersearchagain = 1
							}
							explorerpressedspace =
							break
						}
						else if Errorlevel = Max
						{
							If explorerpressedspace = 1
							{
								explorervar = %explorervar%%A_Space%%loopfileweiter%
							}
							else
							{
								explorervar = %explorervar%%loopfileweiter%
							}
							explorerpressedspace =
							explorersearchagain = 1
							break
						}
						else if Errorlevel = EndKey:Enter
						{
								If A_LoopFileSize = 0
								{
									ToolTip,,,,18
									StringRight, whichfoldertorun, explorervar, 1
									If whichfoldertorun = \
									{
										saveexprorervar = %explorervar%
										saveexplorersearchfile = 2
										Run %A_windir%\explorer.exe /e`, %explorervar%
									}
									else
									{
										saveexplorervar = %A_LoopFileLongPath%
										saveexplorersearchfile = 2
										Run %A_windir%\explorer.exe /e`, %A_LoopFileLongPath%
									}
									Return
								}
								else if A_LoopFileSize > 0
								{
									saveexplorervar = %A_LoopFileLongPath%
									saveexplorersearchfile = 0
									ToolTip,,,,18
									Run %A_LoopFileLongPath%
									Return
								}
								explorersearchagain = 1
								Break
						}
						else if Errorlevel = EndKey:Escape
						{
							ToolTip,,,,18
							Return
						}
			}
		}
		else if ErrorLevel = EndKey:F1
		{
			Loop
			{
				IfEqual, environmentvariablevar, , ToolTip, ENTER A VARIABLE - THEN ENTER OR TAB AND PATH WILL BE CHOOSEN,,,18
				IfNotEqual, environmentvariablevar, , ToolTip, %environmentvariablevar%,,,18
				Input, environmentvariable, L1, {ENTER}{ESC}{BACKSPACE}{TAB}
				If Errorlevel = Max
				{
					environmentvariablevar = %environmentvariablevar%%environmentvariable%
					continue
				}
				else if (Errorlevel = "EndKey:Enter" or Errorlevel = "EndKey:Tab")
				{
					EnvGet, explorervar, %environmentvariablevar%
					If explorervar =
					{
						If environmentvariablevar is alnum
						{
							environmentvariablevarislocal := %environmentvariablevar%
							IfNotExist, %environmentvariablevarislocal%
							{
								environmentvariablevarislocal := %environmentvariablevar%2
								IfExist, %environmentvariablevarislocal%
									explorervar = %environmentvariablevarislocal%
							}
							else
							{
								If environmentvariablevar is alnum
									explorervar := %environmentvariablevar%
							}
						}
					}
					If (InStr(explorervar, ".") = "0" and RegExMatch(explorervar, "\\$") = "0")
						explorervar = %explorervar%\
					else
						explorersearchfile = 0
					environmentvariablevar =
					explorersearchagain = 1
					break
				}
				else if Errorlevel = EndKey:Escape
				{
					explorersearchagain =
					environmentvariablevar =
					break
				}
				else if Errorlevel = EndKey:Backspace
				{
					environmentvariablevar =
				}
			}
		}
		else if Errorlevel = EndKey:F4
		{
			explorervar = %saveexplorervar%
			explorersearchfile = %saveexplorersearchfile%
			explorersearchagain = 1
		}
		else if Errorlevel = EndKey:Down
		{
			ToolTip, SEARCHING....`nPLEASE WAIT...,,,18
			explorersearchagain = 1
			continue
		}
		else if Errorlevel = EndKey:Left
		{
			StringTrimRight, explorervar, explorervar, 1
			explorersearchagain = 1
			continue
		}
		else if Errorlevel = EndKey:Backspace
		{
			StringRight, explorervarcutoff, ecplorervar, 1
			If explorervarcutoff = \
			{
				StringGetPos, explorervarcutoff, explorervar, \, R2, 1
			}
			else
			{
				StringGetPos, explorervarcutoff, explorervar, \, R, 1
			}
			explorervarcutoff += 1
			StringLeft, explorervar, explorervar, %explorervarcutoff%
			;Stringtrimright, explorervar, explorervar, 1
			If explorervar =
			{
				explorersearchagain =
			}
			else if explorervar = :\
				{
					explorervar =
					explorersearchagain =
				}
			else
			{
				explorersearchagain = 1
			}
			explorerpressedspace =
		}
		else if Errorlevel = EndKey:F11
		{
			If explorersearchsubfolders = 0
			{
				explorersearchsubfolders = 1
			}
			else
			{
				explorersearchsubfolders = 0
			}
			explorersearchagain = 1
		}
		else if Errorlevel = EndKey:F12
		{
			If explorersearchfile = 0
				explorersearchfile = 2
			else  ;if explorersearchfile = 1
			{
				explorersearchfile = 0
			}
			;else
			;{
				;explorersearchfile = 0
			;}
			explorersearchagain = 1
		}
		else if Errorlevel = EndKey:Escape
		{
			ToolTip,,,,18
			Return
		}
		else if Errorlevel = EndKey:Enter
		{
				StringRight, explorervarpath, explorervar, 1
				If explorervarpath = `\
				{
					saveexplorervar = %explorervar%
					ToolTip,,,,18
					Run %A_windir%\explorer.exe /e`, %explorervar%
					Return
				}
				explorersearchagain = 1
		}
	}
	ToolTip,,,,18
	Return
}







;_________________________________
;#Include gui.help.txt
1Include_gui_help:
HilfeBox:
{
	ToolTip,,,,20
	IfWinExist, %SCRIPTNAME_VAR% HELP - SELECT TOPIC TO DISPLAY HELP
	{ 
		WinActivate, %SCRIPTNAME_VAR% HELP - SELECT TOPIC TO DISPLAY HELP
		Return
	}
	
	Gui, 2:Default
	;Gui, 2:Add, ListView, r20 w50 -WantF2, Topic
	Gui, 2:Add, ListView, r30 w150 Count50 NoSortHdr AltSubmit +ReadOnly Grid Multi gHelpchange, TOPIC
	
	Gui, 2:Add, Text, x+1, Description
		Gui, 2:Add, Edit, y+6 ReadOnly r32 w700 -Wrap, VERSION 1`.003`nWRITER`: ESC`nCOPYRIGHTED © BY ESC
	LV_Add("", "GENERAL")
	LV_Add("", "HOTKEYS")
	LV_Add("", "MACROS")
	LV_Add("", "FILE/FOLDER STARTER")
	LV_Add("", "WINDOWHIDER")
	LV_Add("", "PROFILECHANGER")
	LV_Add("", "KEYBOARD MOUSE")
	LV_Add("", "WIN INFO")
	LV_Add("", "MONITOR WINDOWS")
	Gui, 2:Show, , %SCRIPTNAME_VAR% HELP - SELECT TOPIC TO DISPLAY HELP
	;WinSetTitle, %SCRIPTNAME_VAR%, , %SCRIPTNAME_VAR% HELP - SELECT TOPIC TO DISPLAY HELP
	;WinWaitClose, %SCRIPTNAME_VAR%
Return
}

Helpchange:
{
	;MsgBox, %Errorlevel%
	If A_GuiEvent = I
	IfInString, Errorlevel, S
	{
		If A_EventInfo = 1
			GuiControl, , Edit1, VERSION 1`.003`nWRITER`: ESC`nCOPYRIGHTED © BY ESC`n`nWITH %SCRIPTNAME_VAR% AND AUTOHOTKEY, YOUR WOKR WILL GET EASIER AND FASTER`n`n  - NO BOTHERING SEARCHING FOR YOUR FILES AND FOLDERS`n  - SAVE YOUR WEBSITES AND START THESE WITH A KEYWORD IN %SCRIPTNAME_VAR% MAIN GUI OR WITH A HOTKEY`n  - WITH AUTOHOTKEY CODE YOU CAN EVEN AUTOMATE NEARLY EVERYTHING. WRITE YOUR MACROS AND START WITH A HOTKEY OR IN %SCRIPTNAME_VAR%`n  - E.g. [WinWait,Explorer,,3], [MsgBox,0,TEST,this is a message box, 4], [InputBox,outputvar,more options...]`n   [StringTrimLeft,outputvar,inputvar,10], [Run, c:\Windows\explorer.exe]`n   [Send, Sends text and keys{ENTER}], [DllCall,see online help for options]...`n  - AND MANY MORE`n `nYOU CAN LEARN MANY USEFULL PROGRAMS AND SPEED UP YOUR WORK WITH COMPUTER INCREDIBLE`n`nTRY IT AND WONDER
		else if A_EventInfo = 2
		{
			GuiControl, , Edit1, START %SCRIPTNAME_VAR% INTERFACE`t`tCAPSLOCK & TAB`n`nFILE AND FOLDER FINDER`t`tCAPSLOCK & SHIFT`n`nRESTART %SCRIPTNAME_VAR%`t`t`tCAPSLOCK & F12`n`nMACRO MANAGEMENT`t`tCAPSLOCK & F5`n`nCREATE NEW MACRO`t`tCAPSLOCK & F8`n`nREPEAD COMMAND`t`tCAPSLOCK & F2`n`nSHOW/HIDE WINDOWS`t`tCAPSLOCK & F4(HIDE), CAPSLOCK & F3(UNHIDE)`n`nPROFILEMANAGER`t`tCAPSLOCK & F1`n`nCANCEL RUNNING MACRO`t`tPRESS KEY "PAUSE/BREAK" WHILE MACRO IS RUNNING`n_______________________________________________________________`n`n`nCAPSLOCK & SHIFT = FILE AND FOLDER FINDER`nCAPSLOCK & TAB = %SCRIPTNAME_VAR% ON(START %SCRIPTNAME_VAR% INTERFACE)`nLCONTROL = LEFT CTRL, RELEASE AND PRESS SHORTLY SHIFT = %SCRIPTNAME_VAR% ON(start %SCRIPTNAME_VAR% GUI INTERFACE)`nCONTROL & < = e.g. in EXPLORER ADRESSBAR type temp and press CONTROL & <`nCTRL & ENTER = SAME AS CONTROL & <`nCAPSLOCK & F1 = PROFILEMANAGER`nCAPSLOCK & F12 = RESTART %SCRIPTNAME_VAR%`nCAPSLOCK & F2 = REPEAT LAST COMMAND`nCAPSLOCK & CTRL = REPEAT LAST COMMAND`nCAPSLOCK & F5 = MACRO MANAGEMENT`nCAPSLOCK & F4 = HIDE WINDOW`nCAPSLOCK & F3 = UNHIDE WINDOW`nCAPSLOCK+F6 = WIN SPY`nCAPSLOCK & F8 = NEW MACRO/PROGRAM(FILE)/FOLDER`nCAPSLOCK & F11 = PAUSE(RUNNING SKRIPT WILL PAUSE PRESS AGAIN TO CONTINUE)`nCAPSLOCK & F9 = HELP`nCONTROL & CAPSLOCK = SPEEDHOTKEYS ON/OFF`nCTRL & CAPSLOCK = SPEEDHOTKEYS ON/OFF`nCAPSLOCK & ENTER = SPEEDHOTKEYS ON`/OFF`nCAPSLOCK & ESC = SPEEDHOTKEYS ON/OFF`nCAPSLOCK & BACKSPACE = SPEEDHOTKEYS ON/OFF`nSCROLLLOCK & BACKSPACE = SPEEDHOTKEYS ON/OFF`nNUMLOCK & BACKSPACE = SPEEDHOTKEYS ON/OFF`nCAPSLOCK & F7 = SHOW ALL HOTKEYS`nCAPSLOCK & F10 = SUSPEND HOTKEYS`n`n_____________________________________`n`nQWERTY KEYBOARD ON: IN %SCRIPTNAME_VAR% INTERFACE PRESS ALT & Y`n`n   - THIS WILL ENABLE QWERTY KEYBORD, YOU CAN TYPE WITH ONE HAND`n   - THE KEYBOARD WILL BE MIRRORED BY PRESSING SPACE & LETTER`n`n   - SPACE & CAPSLOCK  ENTER`n`n    - SPACE & TAB   BACKSPACE`n`n    - SHIFT & SPACE   SPACE`n`n    - ~CONTROL & SPACE  SPACE
		}
		else if A_EventInfo = 3
		{
			GuiControl, , Edit1,  WEBSEITE/FOLDER/PROGRAM/MACRO`n`n`nWITH CAPSLOCK+F8 YOU CAN ADD NEW PROGRAM, FOLDER, WEBSITE, MACRO (FASTER THAN IN MACROMANAGEMENT`n`n    - HIER YOU CAN SET UP YOUR VARIABLES THAT START A WEBSITE, FOLDER, PROGRAM OR MINI SCRIPTS`,`n   `n    - E`.G`. YOU TYPE G IN %SCRIPTNAME_VAR% INTERFACE AND PRESS ENTER TO OPEN HTTP`://WWW`.GOOGLE`.DE`n   `n    - YOU CAN OPEN A FILE OR FOLDER E.G. TYPE PROGS FOR C`:\PROGRAM FILES`n`n  (AFTER THIS YOU WILL BE ABLE TO TYPE YOUR KEY IN %SCRIPTNAME_VAR% TO START YOUR PROGRAM/WEBSEITE/FOLDER/MACRO)`n`n`n`nADVANCED USER CAN WRITE MACROS WITH AUTOHOTKEY CODE.`n`n      - TO CREATE NEW MACRO`, CAPSLOCK+F8 OR ALT+E IN %SCRIPTNAME_VAR% INTERFACE AND THEN M`, THEN VARIABLE AND SO ON`.`.`.`n      - OR PRESS CAPSLOCK+F5 TO OPEN MACRO MANAGER`n`n      - YOU WILL FIND ALL COMMAND THAT ARE SUPPORTED AT THE BOTTOM OF MACRO MANAGEMENT(CAPSLOCK+F5)`n`n      - WITH CAPSLOCK+F2 OR CAPSLOCK+CTRL YOU CAN REPEAT LAST COMMAND`n      `n      - YOU CAN PAUSE MACRO WITH CAPSLOCK & F11`n      `n      - TO STOP RUNNING MACRO, PRESS PAUSE/BREAK.`n`n      - AUTOSTART OF YOUR PROGRAMS:`n        - FOR AUTOSTART ENTER WORD AUTOSTART in NAME`n        - FOR HOTKEYS(ONLY CAPSLOCK/NUMLOCK/SCROLLLOCK + 0-z)`n                   e.g. CAPSLOCKa for CAPSLOCK & A NUMLOCKa for NUMLOCK & A`n`n      - YOU CAN ENTER SEND TEXT INTO THE LINE WITHOUT SEND COMMAND e.g. {TAB}!a^f...`n`n      INSTEAD ErrorLevel use Error_Level`n `n`nSPEEDHOTKEYS: (BEFORE YOU CAN USE THIS, YOU NEED TO TURN ON SPEEDHOTKEYS BY PRESSING STRG & CAPSLOCK OR CAPSLOCK & ENTER)`n`n        - IF YOU ENTER HOTKEY** IN NAME YOU CAN RUN A PROGRAM PRESSING KEY & KEY`n           - e.g. HOTKEYas WOULD START YOUR PROGRAM BY PRESSING A & S`n        `n        - ONLY ALNUM(0-z) ARE POSSIBLE
		}
		else if A_EventInfo = 4
		{
			GuiControl, , Edit1, FILE/FOLDER STARTER`n`n START WITH  - ALT+X -  IN %SCRIPTNAME_VAR% OR - CAPSLOCK+SHIFT -`n`n   - HERE YOU CAN ACCESS FILES AND FOLDERS VERY FAST.`n   `n     - FIRST TYPE DRIVE LETTER, e.g. c (:\ WILL BE ADDED AUTOMATICALLY)`n     - TYPE THE FOLDER OR FILE NAME AND TAKE OVER WITH TAB.`n     - WITH F12 YOU CAN CHANGE WHAT YOU ARE SEARCHING FOR(FILE/FOLDER) FOLDERS CAN BE FOUND MUCH FASTER`n     - WITH F11 YOU CAN SEARCH TROUGH SUBFOLDERS`n     - TO DELETE LAST LETTER/CHARACTER PRESS - LEFT - INSTEAD OF  - BACKSPACE -`n     - PRESSING KEY "DOWN" WILL SHOW NEXT HIT`n     - PRESSING KEY "UP" WILL RESET AND SEARCH FROM START`n     - USE * AS WILDCARD(FOR EXAMPLE *.exe)
		}
		else if A_EventInfo = 5
		{
			GuiControl, , Edit1, WINDOW MANAGER`n`n   - YOU CAN HIDE AND UNHIDE ANY WINDOWS WITH CAPSLOCK & F4 AND CAPSLOCK & F3`n   - YOU CAN ALSO UNHIDE THESE WINDOWs WITH RIGHT MOUSECLICK ON %SCRIPTNAME_VAR% IN YOUR TRAY.
		}
		else if A_EventInfo = 6
		{
			GuiControl, , Edit1, PRESS CAPSLOCK & F1 TO OPEN PROFILECHANGER`n`n   - CLICK ON THE NAME IN THE PROFILELIST TO SELECT PROFILE`n`nTO DELETE OR CREATE A PROFILE`nENTER THE PROFILE INTO THE BOX AND CLICK DELETE/CREATE
		}
		else if A_EventInfo = 7
		{
			GuiControl, , Edit1, MOVING MOUSE`n`n   PRESS ARROW KEYS TO MOVE MOUSE UP DOWN LEFT and RIGHT AS A HOTKEY`n     - E.g. TO MOVE LEFT - PRESS FIRST RIGHT AND HOLD - THEN PRESS LEFT`n            SAME FOR UP  - PRESS FIRST DOWN AND HOLD  - THEN PRESS UP`n   TO MOVE LEFTDOWN, LEFTUP, RIGHTDOWN OR RIGHTUP`n     - PRESS ARROW KEYS LEFT & DOWN(same is DOWN & LEFT), LEFT & UP... AS A HOTKEY`n`nMOUSECLICK`n`n   TO CLICK LEFT MOUSE`n     - PRESS AND HOLD CAPSLOCK THEN PRESS LEFT(PRESS LEFT TWICE TO DOUBLE CLICK)`n`n   TO CLICK RIGHT MOUSE`n     - PRESS AND HOLD CAPSLOCK THEN PRESS RIGHT(PRESS RIGHT TWICE TO DOUBLE CLICK)`n`n   TO CLICK AND HOLD/RELEASE LEFT MOUSE(DRAG AND DROP)`n     - PRESS AND HOLD CAPSLOCK THEN PRESS UP(PRESS UP AGAIN TO RELEASE MOUSE)`n`n   TO CLICK AND HOLD/RELEASE RIGHT MOUSE(DRAG AND DROP)`n     - PRESS AND HOLD CAPSLOCK THEN PRESS DOWN(PRESS DOWN AGAIN TO RELEASE MOUSE)`n`n`nMOUSE SPEED`n`n   TO INCREASE MOUSE SPEED `n     - PRESS RIGHT & CAPSLOCK AS HOTKEY `n     - TO DECREASE LEFT & CAPSLOCK AS HOTKEY`n`n   TO INCREASE ACCELERATION SPEED(THIS IS WHEN YOU HOLD e.g. LEFT & DOWN) `n     - PRESS UP & CAPSLOCK AS HOTKEY`n     - TO DECREASE DOWN & CAPSLOCK
		}
		else if A_EventInfo = 8
		{
			GuiControl, , Edit1, WIN SPY`n`nTO START, MOVE MOUSE to the WINDOW/CONTROL/POSITION AND PRESS CAPSLOCK & F6`n`nTO COPY A VALUE, NAVIGATE TO IT AND PRESS ENTER OR CLICK ON IT
		}
		else if A_EventInfo = 9
		{
			GuiControl, , Edit1, WINWATCHER`n`nPRESS CAPSLOCK & SPACE TO START/CLOSE`n`nPRESS CAPSLOCK & + TO ADD A WINDOW TO WINWATCHER(CAPSLOCK & - TO REMOVE)`n`nPRESS CAPSLOCK + ALT TO HIDE/SHOW WINWATCHER`n`nUSE CONTROL & SHIFT & LEFTMOUSE TO MARK A REGION THAT YOU WANT TO MONITOR
		}
		else if A_EventInfo = 10
		{
			GuiControl, , Edit1, hallo wie gehts
		}
	}
	Return
}

2GuiClose:
	Gui, 2:Destroy
	Gui, Default
Return

2GuiEscape:
	Gui, 2:Destroy
	Gui, Default
Return









;__________________________________
;#Include gui.macromanagement.txt
1Include_gui_macromanagement:
Macrokeys:
{
	ToolTip,,,,20
	IfWinExist, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE
	{
		WinActivate, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE
		Return
	}
	StringLeft, currentisdefault, allprofiles, InStr(allprofiles, "|")-1
	allprofilestoload = %allprofiles%
	IfNotEqual, currentisdefault, %DEFAULT%
	{
		StringReplace, allprofilestoload, allprofilestoload, |%DEFAULT%,
		allprofilestoload = %default%|%allprofilestoload%
	}
	Stringsplit, allprofilestoload, allprofilestoload, |
	Gui +OwnDialogs +LastFound
	Gui, 8:+owner1  ; Make #2 window owned by #1 window.
	Gui, 8:+owner  ; Make #2 window owned by script's main window to prevent display of a taskbar button.To 
	Gui, font, bold
	Menu, MacroMenu, Add, &Save Macro, ChangeMacrokeysfile  ; See remarks below about Ctrl+O.
	Menu, MacroMenu, Add, Edit &Macro, HiEdit
	Menu, MacroMenu, Add, &Delete Macro, DeleteMacro
	Menu, MacroMenu, Add, De/&Encrypt Macro, Encryptbutton
	Menu, MacroMenu, Add, &Clear Fields, Clearmacrokeys
	Menu, MacroMenu, Add, E&xit MacroManagement, GuiClose
	Menu, InsertMenu, Add, &Copy File To Clipboard, Insertfile
	Menu, InsertMenu, Add, Copy &Folder To Clipboard, Insertfolder
	Menu, ProfileMenu, Add, &ProfileManager, Changeprofile
	Menu, ImportMenu, Add, Imp&ort Macro, Import
	Menu, ImportMenu, Add, &Apply new Config File, Restoreini
	Menu, ImportMenu, Add, &Export macros to html, Exporttohtml
	Menu, ImportMenu, Add, &Display config file, displayconfigfile
	Menu, HelpMenu, Add, &Help, HilfeBox
	Menu, HelpMenu, Add, &AutoHotkey Online, Morehelponline
	Menu, MyMenuBar, Add, &Macro, :MacroMenu  ; Attach the two sub-menus that were created above.
	Menu, MyMenuBar, Add, &Insert, :InsertMenu
	Menu, MyMenuBar, Add, &Profilemanager, :ProfileMenu
	Menu, MyMenuBar, Add, Imp&ort/Export, :ImportMenu
	Menu, MyMenuBar, Add, &Help, :HelpMenu
	Gui, Menu, MyMenuBar
	Gui, Add, Button, w675 gChangecurrentprofileinmacro, CURRENT PROFILE:  -  %DEFAULT%  -  CLICK TO &APPLY SELECTED TAB TO BE DEFAULT PROFILE
	Gui, font, norm
	Gui, Add, Tab, xs Buttons w675 vActiveTab, %allprofilestoload%
	StringLeft, currenttabprofile, allprofilestoload, InStr(allprofilestoload, "|")-1
	Loop, Read, %config%
	{
		Loop 4
		helpvalue%A_Index% =
		helpvaluefirst =
		helpvalue := A_LoopReadLine
		StringLeft, helpvaluefirst, helpvalue, 1
		If helpvaluefirst = [
		{
			StringTrimLeft, helpvalue, helpvalue, 1
			StringTrimRight, helpvalue, helpvalue, 1
			currentprofile = %helpvalue%
			Gui, Tab, %helpvalue%,, Exact
			Gui, Add, ListView, r12 w660 Count300 AltSubmit +ReadOnly Grid Multi gMacrokeyschange vList%currentprofile%, MACRO KEYWORD|NAME/AUTOSTART/CAPSLOCK/HOTEKEY|MACRO COMMANDS|PARAMETERS
			continue
		}
		Stringsplit, helpvaluecheck, helpvalue, `=, %A_Space%
		helpvaluecheck = %helpvaluecheck%
		If (helpvaluecheck1 = "F93DHH98E08776AC" or helpvalue = "" or helpvaluecheck1 = "defaultprofile")
		continue
		StringReplace, helpvalue, helpvalue, `=, `°,
		Stringsplit, helpvalue, helpvalue, `°%programseparator%, %A_Space%
		;MsgBox % helpvalue3
		helpend := LV_Add("",helpvalue1, helpvalue2,helpvalue3,helpvalue4)
		If helpend = 0
		break
	}
	Loop 4
		helpvalue%A_Index% =
	helpvaluefirst =
	Gui, Tab
	Gui, font, bold
	Gui, Add, Button, xs Default gChangeMacrokeysfile, _      &S A V E      _`nM A C R O
	Gui, Add, Button, x+0 gENCRYPTBUTTON, -     &ENCRYPT`/DECRYPT MACRO     -`n!!! TO DECRYPT LAST 3 KEYS OF YOR MACRO WILL BE REQUIRED`, PLEASE REMEMBER !!!
	Gui, Add, Text, xs, KEY&WORD             :
	Gui, font, norm
	Gui, Add, Edit, x+1 -WantTab -WantReturn w120, EXAMPLE: g
	Gui, font, bold
	Gui, Add, Button, x+1 gCLEARMACROKEYS, C&LEAR
	Gui, Add, Button, x+1 gHilfeBox, &HELP
	Gui, Add, Button, x+1 gChangeprofile, &PROFILEMANAGER
	Gui, Add, Edit, x+1 vFiltermacrotext -WantTab, FILTERTERM
	Gui, Add, DropDownList, x+1 vFiltermacro gFiltermacronow w116, SET FILTER ON||ALL|KEY|NAME|MACRO|PARAMETERS
	Gui, Add, Text, xs, NA&ME                    :
	Gui, font, norm
	Gui, Add, Edit, x+1 -WantTab -WantReturn w550, YOU MUST ENTER NAME AND|OR OPTIONS FOR EXAMPLE: GOOGLE CAPSLOCKg
	Gui, font, bold
	Gui, Add, Text, xs, PA&RAMS                :
	Gui, font, norm
	Gui, Add, Edit, x+1 -WantTab -WantReturn w550, ENTER PARAMETERS HERE. FOR EXAMPLE http://www.web.de
	Gui, font, bold
	Gui, Add, Text, xs, MACR&O                  :
	;Gui, font, norm
	;Gui, Add, Edit, x+1 +WantTab r17 w550, [HERE YOU NEED TO ENTER YOUR MACRO, FOLDER OR INTERNET EXLORER]`n`nE.G.: C:\Program Files\Internet Explorer\iexplore.exe`n`n(WHEN MACRO IS A PROGRAM LIKE WEBBROWSER, PARAMS CAN BE A WEBSITE, FOLDER OR START PARAMETERS. For EXAMPLE: /e or c:\ for C:\Windows\explorer.exe)`n`nIF YOU WANT TO USE AUTOHOTKEY MACRO, PARAMS MUST BE EMPTY, ENTER FOR EXAMPLE:`nRun, C:\Program Files\Internet Explorer\iexplore.exe www.google.de`n`nOR`n`n!a`nSleep, 500`n!s`nLoop 2`n{`nMsgBox, test`n}
	
	
	hwnd := WinExist()

	;CreateMenu()
	hEdit := HE_Add(hwnd,131,390,550,229, "HSCROLL VSCROLL HILIGHT")


	fStyle := "s8" ,	fFace  := "Courier New"
	HE_SetFont( hEdit, fStyle "," fFace)

	SetColors(hEdit)
	;msgbox % HE_GetColors(hEdit)


	HE_SetTabWidth(hEdit, 4)
	HE_LineNumbersBar(hEdit, "automaxsize"), lineNumbers := true
	HE_AutoIndent(hedit, true), autoIndent := true

	HE_SetKeywordFile( A_ScriptDir "\Keywords.hes")
	
	Gui, font, bold
	Gui, Add, Button, xs y460 gINSERTFOLDER, COPY FOLDER`nTO CL&IPBOARD
	Gui, Add, Button, xs y420 gINSERTFILE, COPY &FILE`nTO CLIPBOARD
	Gui, Add, Button, xs y500 gHiEdit, 	E &D I T`nM A C R O`nI N`nE D I T O R
	Gui, Add, Button, xs y570 gMorehelponline, &GET HELP`nONLINE ON`n.AUTOHOTKEY.
	Gui, Add, DropDownList, vProgramChoise gChooseprogram w162 xs y625, COMMANDS||%workingcommandsinfo%
	Gui, font, norm
	Gui, Add, Edit, x+1 r3 -WantTab -WantReturn w508 Readonly
	Gui, font, bold
	Gui, Add, Edit, xs y650 -WantTab -WantReturn w161 gGetHelp,
	Gui, Add, Button, xs gCopyfromhelp, &COPY TO CLIPBOARD   ->
	Gui, font, norm
	Gui, Add, Edit, x+1 -WantTab -WantReturn w507 Readonly,
	Gui, Show,, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE
	ControlSetText, HiEdit1, % "here you need to enter your macro, folder/file or your internet exlorer`nfor example: C:\Program Files\Internet Explorer\iexplore.exe`nwhen macro(entry here) is a program like webbrowser, `n	-	params can be a website`n	-	folder or start parameters.`n	-	e.g.: /e or c:\ (PARAMS) for C:\Windows\explorer.exe(in MACRO)`n`nif you want to use ahk code, params must be empty,`nfor example:`nRun, C:\Program Files\Internet Explorer\iexplore.exe www.google.de`nWinWaitActive, Google"
	Gui, Submit, Nohide
	GuiControl, Focus, List%ActiveTab%
	Return
}

GuiClose:
{
	Gui, Destroy
	Exit
}

GuiEscape:
{
	MsgBox, 4, EXIT?, DO YOU WANT TO CLOSE?, 3
	IfMsgBox Yes
	Gui, Destroy
	Exit
}



Filtermacronow:
{
	Gui, Submit, NoHide
	
	If Filtermacro = SET FILTER ON
	{
		Return
	}
	rowstofilter := LV_GetCount()
	MsgBox, 4, FILTER MACROS?, DO YOU WANT TO APPLY FILTER`nFILTER ON: %Filtermacro%`nFILTER: %Filtermacrotext%, 5
	IfMsgBox No
		Return
	If Filtermacro = ALL
	{
		
		Loop % LV_GetCount()
		{
			LV_GetText(texttofilter1, rowstofilter, 1)
			LV_GetText(texttofilter2, rowstofilter, 2)
			LV_GetText(texttofilter3, rowstofilter, 3)
			LV_GetText(texttofilter4, rowstofilter, 4)
    	IfNotInString, texttofilter1, %filtermacrotext%
      {
      	IfNotInString, texttofilter2, %filtermacrotext%
      	{
      		IfNotInString, texttofilter3, %filtermacrotext%
      		{
      			IfNotInString, texttofilter4, %filtermacrotext%
      			{
      				LV_Delete(rowstofilter)
      			}
      		}
      	}
      }
      rowstofilter--
		}
	}
	else if Filtermacro = KEY
	{
		Loop % LV_GetCount()
		{
			LV_GetText(texttofilter, rowstofilter, 1)
    	IfNotInString, texttofilter, %filtermacrotext%
      {
      	LV_Delete(rowstofilter)  
      }
      rowstofilter--
		}
	}
	else if Filtermacro = NAME
	{
		Loop % LV_GetCount()
		{
			LV_GetText(texttofilter, rowstofilter, 2)
    	IfNotInString, texttofilter, %filtermacrotext%
      {
      	LV_Delete(rowstofilter)  
      }
      rowstofilter--
		}
	}
	else if Filtermacro = MACRO
	{
		Loop % LV_GetCount()
		{
			LV_GetText(texttofilter, rowstofilter, 3)
    	IfNotInString, texttofilter, %filtermacrotext%
      {
      	LV_Delete(rowstofilter)  
      }
      rowstofilter--
		}
	}
	else if Filtermacro = PARAMETERS
	{
		Loop % LV_GetCount()
		{
			LV_GetText(texttofilter, rowstofilter, 4)
    	IfNotInString, texttofilter, %filtermacrotext%
      {
      	LV_Delete(rowstofilter)  
      }
      rowstofilter--
		}
	}
	
	Return
}

ChooseProgram:
	Gui, Submit, NoHide
	GuiControl, , Edit6, %programchoise%
Return

Changecurrentprofileinmacro:
{
	Gui, Submit, NoHide
	Gui, Destroy
	IniWrite, %ActiveTab%, %config%, DEFAULT, defaultprofile
	Loop, Read, %config%
	{
		linevalue := A_LoopReadLine
		;FileReadLine, linevalue, %config%, %A_Index%
		;If Errorlevel
		;	break
		StringLeft, linevaluefirst, linevalue, 1
		Stringsplit, linevalue, linevalue, `=, %A_Space%
		If (linevaluefirst = "[" or linevalue1 = "F93DHH98E08776AC" or linevalue = "" or linevalue1 = "defaultprofile")
			continue
		;MsgBox % %linevalue1%1
		SetEnv, %linevalue1%,
		IfNotEqual, %linevalue1%1,
			SetEnv, %linevalue1%1,
		IfNotEqual, %linevalue1%2,
			SetEnv, %linevalue1%2,
		IfNotEqual, %linevalue1%3,
			SetEnv, %linevalue1%3,
		IfNotEqual, %linevalue1%4,
			SetEnv, %linevalue1%4,
	}
	GoSub, Restartini
	;Return
	Goto, Macrokeys
	
}
	
CLEARMACROKEYS:
{
	;GuiControl, , Edit1,
	GuiControl, , Edit3,
	GuiControl, , Edit4,
	ControlSetText, HiEdit1, 
Return
}

Insertfolder:
{
	
	FileSelectFolder, Foldertoinsert
	Clipboard := Foldertoinsert
	return
}

Insertfile:
{
	
	FileSelectFile, Filetoinsert
	Clipboard := Filetoinsert
	return
}

Copyfromhelp:
{
	Clipboard = [%helpfoundword%]
	Return
}

Morehelponline:
{
	Stringleft, onlinehelpfor, helpfoundword, InStr(helpfoundfrom, ",", CaseSensitive = true)
	StringTrimRight, onlinehelpfor, onlinehelpfor, 1
	StringReplace, onlinehelpfor, onlinehelpfor, %A_Space%,,A
	StringReplace, onlinehelpfor, onlinehelpfor, [,,A
	If onlinehelpfor =
	{
		Run %webbrowserfile% http://www.autohotkey.com/docs/commands.htm
	}
	else
	{
		Run %webbrowserfile% http://www.autohotkey.com/docs/commands/%onlinehelpfor%.htm
	}
	Return
}

ENCRYPTBUTTON:
{
	Gui, Submit,NoHide
	
	ControlGetText, helpvaluenew, HiEdit1
	If helpvaluenew =
	{
		
		Return
	}
	If helpvaluenew is digit
	{
		MsgBox 4, DECRYPT, MACRO IS ALREADY ENCRYPTED.`n(YOU CANNOT ENCRYPT FIGURES - ADD TEXT TO YOUR MACRO)`n`nDO YOU WANT TO DECRYPT MACRO?
		IfMsgBox YES
		{
			decryptmakrokeys = %helpvaluenew%
			StringReplace, decryptmakrokeys, decryptmakrokeys, `n, %macroseparator%, A
			Decryptmakro(decryptmakrokeys, config)
			StringReplace, decryptmakrokeys, decryptmakrokeys, %macroseparator%, `n, A
			ControlSetText, HiEdit1, %decryptmakrokeys%
		}
		
		Return
	}
	MsgBox, 4, ENCRYPT?, !!!REMEMBER LAST 3 CHARACTERS!!!`n`nENCRYPT?
	IfMsgBox Yes
	{
		encryptmakrokeys = %helpvaluenew%
		StringReplace, encryptmakrokeys, encryptmakrokeys, `n, %macroseparator%, A
		Encryptmakro(encryptmakrokeys, config)
		StringReplace, encryptmakrokeys, encryptmakrokeys, %macroseparator%, `n, A
		ControlSetText, HiEdit1, %encryptmakrokeys%
	}
	
	Return
}

GetHelp:
{
	GuiControlGet, helpsearch, , Edit6
	;MsgBox, %helpsearch%
	IfInString, helpsearch, (
		StringLeft, helpsearch, helpsearch, InStr(helpsearch, "(")-2
	helpsearch = %helpsearch%
	StringTrimLeft, helpfoundfrom, autohotkeyhelp, InStr(autohotkeyhelp, "("helpsearch, CaseSensitive = true)
	;MsgBox % helpfoundfrom
	StringLeft, helpfoundword, helpfoundfrom, InStr(helpfoundfrom, ")", CaseSensitive = true)
	StringTrimRight, helpfoundword, helpfoundword, 1
	StringSplit, helpfoundword, helpfoundword, .
	GuiControl, , Edit7, %helpfoundword1%
	GuiControl, , Edit5, %helpfoundword2%
	Return
}

Macrokeyschange:
{
	Gui, Submit, NoHide
	Gui, 1:ListView, List%ActiveTab%
	If (A_GuiEvent = "Normal" or A_GuiEvent = "I")
	{
		If A_GuiEvent = I
		{
			IfNotInString, Errorlevel, S
				Return
		}
		If A_EventInfo > 0
		{
			GuiControl, , Edit1,
			GuiControl, , Edit3,
			GuiControl, , Edit4,
			ControlSetText, HiEdit1,
			LV_GetText(helpvaluechangekey, A_EventInfo, 1)
			selectedrow = %A_EventInfo%
			selectedkey  := helpvaluechangekey
			If (%helpvaluechangekey%2 = "" || ActiveTab != DEFAULT)
			{
				LV_GetText(helpvaluenew, A_EventInfo, 3)
				LV_GetText(helpvaluenamenew, A_EventInfo, 2)
				LV_GetText(helpvalueparam, A_EventInfo, 4)
				StringLen, helpvaluenewlength, helpvaluenew
				If helpvaluenewlength = 8190
				{
					MsgBox, 4, MACRO TOO LONG, PROFILE: %ActiveTab% MUST BE DEFAULT PROFILE IF YOU WANT TO EDIT THIS MACRO`n  (as this macro is longer than 8190 characters`n   it must be existing in the environment, so profile must be changed)`nCONSIDER USING FILEREAD OR INIREAD TO READ INTO A VARIABLE`n`nAPPLY PROFILE: %ActiveTab%?
					IfMsgBox Yes
					{
						GoSub, Changecurrentprofileinmacro
						GoTo, Macrokeys
					}
					else
					{
						
						Return
					}
				}
			}
			else
			{
				helpvaluenamenew := %helpvaluechangekey%1
				helpvaluenew := %helpvaluechangekey%2
				helpvalueparam := %helpvaluechangekey%3
			}
			StringReplace, helpvaluenew, helpvaluenew, %macroseparator%, `n, A

			;MsgBox % helpvaluechangekey
			GuiControl, , Edit1, %helpvaluechangekey%
			GuiControl, , Edit3, %helpvaluenamenew%
			GuiControl, , Edit4, %helpvalueparam%
			ControlSetText, HiEdit1, %helpvaluenew%
		}
	}
	Return
}

ChangeMacrokeysfile:
{
	IfWinNotExist, %SCRIPTNAME_VAR% MACRO MANAGEMENT
		Return
	Gui, Submit, NoHide
	
	Gui, 1:ListView, List%ActiveTab%
	Sleep, 100
	GuiControlGet, helpvaluechangekey, , Edit1
	If helpvaluechangekey =
	{
		Return
	}
	RegExMatch(helpvaluechangekey, "^\w+$", setupkeycheck)
	If (helpvaluechangekey != setupkeycheck) ;If helpvaluechangekey is not alnum
	{
		MsgBox, 0, FORBIDDEN CHARACTER IN NAME, ONLY ALPHANUMERIC CHARACTERS ARE ALLOWED
		Return
	}
	GuiControlGet, helpvaluenamenew, , Edit3
	GuiControlGet, helpvalueparam, , Edit4
	ControlGetText, helpvaluenew, HiEdit1
	StringReplace, helpvaluenew, helpvaluenew, `r, , A
	StringReplace, helpvaluenew, helpvaluenew, `n, %macroseparator%, A
		;MsgBox, a %A_EventInfo% s %selectedrow%
		helpnewvalue := helpvaluenamenew . programseparator . helpvaluenew . programseparator . helpvalueparam
		;MsgBox % helpnewvalue
		If helpnewvalue = %programseparator%%programseparator%
		{
			MsgBox, 4, DELETE MACRO, DO YOU WANT TO DELETE MACRO: %helpvaluechangekey% IN PROFILE %ActiveTab%?
			IfMsgBox Yes
			{
				IniDelete, %config%, %ActiveTab%, %helpvaluechangekey%
				SetEnv, %helpvaluechangekey%,
				LV_Delete(selectedrow)
				Gosub, RESTARTINI
			}
			
			Return
		}
		StringLeft, helpnewvaluename, helpnewvalue, InStr(helpnewvalue, programseparator)
		MsgBox, 4, CHANGE MACRO, DO YOU WANT TO CHANGE MACRO?`n`nPROFILE: `t%ActiveTab%`nKEYWORD: `t%helpvaluechangekey%`nNAME: `t`t%helpnewvaluename%
		IfMsgBox Yes
		{
			If helpvaluechangekey = setwebbrowser
			{
				webbrowserfile = %helpvaluenew%
			}
			If helpvaluechangekey = setmouse
			{
				StringSplit, setmousesettings, helpvaluenew, |
				standardspeed = %setmousesettings1%
				accellerationspeed = %setmousesettings2%
			}
			If helpvaluechangekey = setwinwatcher
			{
				winwatcherspeed = %helpvaluenew%
				winwatcherspeed *= 1000
			}
			If helpvaluechangekey = setdebugger
			{
				debuggerison = %helpvaluenew%
				debuggerslowdown = %helpvalueparam%
			}
			If linevalue1 = setautostart
			{
				StringSplit, changeautostart, linevalue, %programseparator%
				autostarton = %changeautostart2%
			}
			checkifvarisautostart := %helpvaluechangekey%
			checkifvarisautostart = %checkifvarisautostart%
			;MsgBox % checkifvarisautostart
			StringLower, checkifvarisautostart, checkifvarisautostart
			IfInString, checkifvarisautostart, capslock
			{
				StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "capslock", CaseSensitive = false)+8, 1
				;Msgbox % favnumber helpvaluechangekey
				IfInString, hotkeykeys, %favnumber%
				capslockvar%favnumber% =
			}
			IfInString, checkifvarisautostart, scrolllock
			{
				StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "scrolllock", CaseSensitive = false)+10, 1
				;Msgbox % favnumber helpvaluechangekey
				IfInString, hotkeykeys, %favnumber%
				scrolllockvar%favnumber% =
			}
			IfInString, checkifvarisautostart, numlock
			{
				StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "numlock", CaseSensitive = false)+7, 1
				;Msgbox % favnumber helpvaluechangekey
				IfInString, hotkeykeys, %favnumber%
				numlockvar%favnumber% =
			}
			IfInString, checkifvarisautostart, hotkey
			{
				StringMid, favnumber2, checkifvarisautostart, InStr(checkifvarisautostart, "hotkey", CaseSensitive = false)+6, 2
				IfInString, hotkeys, %favnumber2%
				{
					hotkeyvar%favnumber2% =
					StringLeft, hotkeya, favnumber2, 1
					StringRight, hotkeyb, favnumber2, 1
					hotkey, %hotkeya% & %hotkeyb%, Off
					StringReplace, hotkeyslist, hotkeyslist, %favnumber2%., 
					StringSplit, hotkeyslist, hotkeyslist, .
					hotkeyslist0 -= 1
				}
			}
			;MsgBox % helpnewvalue config helpvaluechangekey
			FileRead, filecontent, %config%
			IfInString, filecontent, %helpvaluechangekey%=
			{
				newkey =
			}
			else
			{
				newkey = 1
			}
			IniWrite, %helpnewvalue%, %config%, %ActiveTab%, %helpvaluechangekey%
			If (helpvaluechangekey = selectedkey)
			{
				LV_Modify(selectedrow, "", helpvaluechangekey, helpvaluenamenew, helpvaluenew, helpvalueparam)
			}
			else if helpvaluechangekey =
			{
				
				Return
			}
			else
			{
				LV_Add("", helpvaluechangekey, helpvaluenamenew, helpvaluenew, helpvalueparam)
			}
			Sleep, 50
			LV_GetText(helpvaluenewcheck, selectedrow, 3)
			If ActiveTab = %DEFAULT%
			{
			}
			else
			{
				IfNotEqual, helpvaluenewcheck, %helpvaluenew%
				{
					If newkey =
					{
						Gui, 1:Destroy
						GoTo, Macrokeys
					}
				}
				
				Return
			}
			IniRead, %helpvaluechangekey%, %config%, %ActiveTab%, %helpvaluechangekey%, %helpvaluechangekey%
			;Sleep, 50
			Stringsplit, %helpvaluechangekey%, %helpvaluechangekey%, %programseparator%, %A_Space%%A_Tab%
			checkifvarisautostart := %helpvaluechangekey%
			checkifvarisautostart = %checkifvarisautostart%
			;MsgBox % checkifvarisautostart
			StringLower, checkifvarisautostart, checkifvarisautostart
			IfInString, checkifvarisautostart, capslock
			{
				StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "capslock", CaseSensitive = false)+8, 1
				;Msgbox % favnumber helpvaluechangekey
				IfInString, hotkeykeys, %favnumber%
				capslockvar%favnumber% = %helpvaluechangekey%
			}
			IfInString, checkifvarisautostart, scrolllock
			{
				StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "scrolllock", CaseSensitive = false)+10, 1
				;Msgbox % favnumber helpvaluechangekey
				IfInString, hotkeykeys, %favnumber%
				scrolllockvar%favnumber% = %helpvaluechangekey%
			}
			IfInString, checkifvarisautostart, numlock
			{
				StringMid, favnumber, checkifvarisautostart, InStr(checkifvarisautostart, "numlock", CaseSensitive = false)+7, 1
				;Msgbox % favnumber helpvaluechangekey
				IfInString, hotkeykeys, %favnumber%
				numlockvar%favnumber% = %helpvaluechangekey%
			}
			IfInString, checkifvarisautostart, hotkey
			{
				StringMid, favnumber2, checkifvarisautostart, InStr(checkifvarisautostart, "hotkey", CaseSensitive = false)+6, 2
				IfInString, hotkeys, %favnumber2%
					hotkeyvar%favnumber2% = %helpvaluechangekey%
				StringLeft, hotkeya, favnumber2, 1
				StringRight, hotkeyb, favnumber2, 1
				
				If (InStr(hotkeys, favnumber2 ".") or InStr(hotkeys, favnumber2 "."))
				{
					Hotkey, %hotkeya% & %hotkeyb%, RunHotkey, Off
					hotkeyslist = %hotkeyslist%%favnumber2%.
					StringSplit, hotkeyslist, hotkeyslist, .
					hotkeyslist0 -= 1
				}
			}
		}
		else
		{
			
			Return
		}
		IfNotEqual, helpvaluenewcheck, %helpvaluenew%
		{
			Gui, 1:Destroy
			GoTo, Macrokeys
		}
		
		Return
}

DeleteMacro:
{
	Gui, Submit, NoHide
	
	MsgBox, 4, DELETE MACRO, DO YOU WANT TO DELETE MACRO: %helpvaluechangekey% IN PROFILE %ActiveTab%?
	IfMsgBox Yes
	{
		IniDelete, %config%, %ActiveTab%, %helpvaluechangekey%
		SetEnv, %helpvaluechangekey%,
		LV_Delete(selectedrow)
		Gosub, RESTARTINI
	}
	
	Return
}

displayconfigfile:
	Run, %config%
Return

Exporttohtml:
{
	exporthotkeyed =
	MsgBox, 4, EXPORT ALL?, PRESS YES IF YOU WANT TO EXPORT ALL MACROS`nPRESS NO IF YOU WANT TE EXPORT ONLY HOTKEYED MACROS`nFOR EXAMPLE CAPSLOCKa
	IfMsgBox No
		exporthotkeyed = 1
	FileDelete, %SCRIPTNAME_VAR%_html_export.html
	htmlexport = <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html>`n<head>`n<title>%SCRIPTNAME_VAR%_html_export</title>`n</head>`n<body>`n
	Loop, Read, %config%
	{
		linevalue := A_LoopReadLine
		If linevalue =
			continue
		StringLeft, linevaluefirst, linevalue, 1
		Stringsplit, linevalue, linevalue, `=, %A_Space%
		If (linevaluefirst = "[")
		{
			StringTrimLeft, linevalue, linevalue, 1
			StringTrimRight, linevalue, linevalue, 1
			htmlexport .= "</table>`n<H1>PROFILE: " . linevalue . "</H1>`n<table border=" . "1" . ">`n"
			exportprofile = %linevalue%
			continue
		}
		If (linevaluefirst = "[" or linevalue1 = "F93DHH98E08776AC" or linevalue1 = "" or linevalue1 = "defaultprofile" or linevalue1 = "setautostart" or linevalue1 = "setdebugger" or linevalue1 = "setwinwatcher" or linevalue1 = "setmouse" or linevalue1 = "setwebbrowser")
			continue
		exportkey := linevalue1
		Loop 4
		{
			key%A_Index% =
		}
		IniRead, %exportkey%, %config%, %exportprofile%, %exportkey%, %exportkey%
		;VarSetCapacity(%key%2, 5120)
		Stringsplit, %exportkey%, %exportkey%, %programseparator%, %A_Space%%A_Tab%
		autostartvar := %exportkey%
		exportname := %exportkey%1
		If exporthotkeyed = 1
		{
			If exportname not contains CAPSLOCK,SCROLLLOCK,NUMLOCK,HOTKEY
				continue	
		}
		htmlexport .= "<tr>`n<td><b>" . exportkey . "</b></td>`n<td>" . exportname . "</td>`n<td>" . exportprofile . "</td>`n</tr>`n"
	}
	FileAppend, %htmlexport%, %SCRIPTNAME_VAR%_html_export.html
	Run, %SCRIPTNAME_VAR%_html_export.html
	Return
}

DISPinWEB_AUS:
{
	Gui, Submit, NoHide
	Gui, 1:ListView, List%ActiveTab%
	ControlGetText, exportmacro, HiEdit1
	FileDelete, %SCRIPTNAME_VAR%_html_export.html
	htmlexport = <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html>`n<head>`n<title>%SCRIPTNAME_VAR%_html_export</title>`n</head>`n<body>`n
	Loop, Parse, exportmacro, `n
	{
		If A_Index = 1
			htmlexport .= "<table border=" . "1" . ">`n"
		If A_LoopField =
			continue
		htmlexport .= "<tr>`n<td>" . A_LoopField . "</td>`n</tr>`n"
	}
	htmlexport .= "</table>`n"
	FileAppend, %htmlexport%, %SCRIPTNAME_VAR%_html_export.html
	Run, %SCRIPTNAME_VAR%_html_export.html
	Return
}


1Include_hiedit:
	;HiEdit
EDITOR:
{
	Gui, 9:+LastFound +Resize
	hwnd := WinExist()
	hEdit := HE_Add(hwnd,0,0,800,600, "HSCROLL VSCROLL TABBED HILIGHT")
	fStyle := "s8" ,	fFace  := "Courier New"
	HE_SetFont( hEdit, fStyle "," fFace)
	SetColors(hEdit)
	HE_SetTabWidth(hEdit, 4)
	HE_LineNumbersBar(hEdit, "automaxsize"), lineNumbers := true
	HE_AutoIndent(hedit, true), autoIndent := true
	HE_SetKeywordFile( A_ScriptDir "\Keywords.hes")
	Gui, 9:Show, w800 h600, AHK EDITOR
	GoSub, Open_File
	return
}


9GuiClose:
{
	Gui, 9:Destroy
	EmptyMem()
	return
}



HiEdit:
{
	Hotkey, CAPSLOCK & F5, Off
	ControlGetText, texttoedit, HiEdit1, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE
	WinHide, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE AHK_class AutoHotkeyGUI
	Gui, 8:+LastFound +Resize
	
	hwnd := WinExist()

	;CreateMenu()
	hEdit := HE_Add(hwnd,0,0,800,600, "HSCROLL VSCROLL TABBED HILIGHT")


	fStyle := "s8" ,	fFace  := "Courier New"
	HE_SetFont( hEdit, fStyle "," fFace)

	SetColors(hEdit)
	;msgbox % HE_GetColors(hEdit)


	HE_SetTabWidth(hEdit, 4)
	HE_LineNumbersBar(hEdit, "automaxsize"), lineNumbers := true
	HE_AutoIndent(hedit, true), autoIndent := true

	HE_SetKeywordFile( A_ScriptDir "\Keywords.hes")
	;IfNotExist, editor.ahk
	;FileAppend, , editor.ahk
	;HE_OpenFile( hEdit, "editor.ahk" )
	Gui, 8:Show, w800 h600, HiEdit
	ControlSetText, HiEdit1, %texttoedit%, HiEdit AHK_class AutoHotkeyGUI
Send ^{HOME}
return
}

8GuiEscape:
8GuiClose:
{
	ControlGetText, texttoedit, HiEdit1, HiEdit AHK_class AutoHotkeyGUI
	Gui, 8:Destroy
	WinShow, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE AHK_class AutoHotkeyGUI
	WinActivate, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE AHK_class AutoHotkeyGUI
	ControlSetText, HiEdit1, %texttoedit%, %SCRIPTNAME_VAR% MACRO MANAGEMENT - TO SORT A COLUMN CLICK HEADLINE
	Hotkey, CAPSLOCK & F5, On
	EmptyMem()
	return
}

Open_File:
{
	FileSelectFile, fn
		if Errorlevel
			return
		HE_OpenFile(hEdit, fn)
	Return
}

Close_file:
	HE_CloseFile(hEdit, -1)
Return

New_File:
{
	HE_NewFile(hEdit)
Return
}

Save_File:
{
	FileSelectFile, fn, S 16
	if (Errorlevel)
		return
	HE_SaveFile(hEdit, fn, -1)
	return
}

CmnDlg_Find( hGui, lbl, flags="d", deff="") {
	static FINDMSGSTRING = "commdlg_FindReplace"
	static FR_DOWN=1, FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_NOWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000
	static buf, FR, len := 256

	if !Islabel(lbl)
		return "Invalid Label"

	
	f := 0
	f |= InStr(flags, "d")  ? FR_DOWN : 0 
	f |= InStr(flags, "c")  ? FR_MATCHCASE : 0
	f |= InStr(flags, "w")  ? FR_WHOLEWORD : 0
	f |= InStr(flags, "-d") ? FR_HIDEUPDOWN : 0
	f |= InStr(flags, "-w") ? FR_HIDEWHOLEWORD :0 
	f |= InStr(flags, "-c") ? FR_HIDEMATCHCASE :0

	if FR =
		VarSetCapacity(FR, 40, 0), VarSetCapacity(buf, len)
	
	if deff !=
		buf := deff
	
	NumPut( 40,		FR, 0)	;size
	NumPut( hGui,	FR, 4)	;hwndOwner
	NumPut( f,		FR, 12)	;Flags
	NumPut( &buf,	FR, 16)	;lpstrFindWhat
	NumPut( len,	FR, 24) ;wFindWhatLen


	CmnDlg_callback(lbl,"","","")
	OnMessage( DllCall("RegisterWindowMessage", "str", FINDMSGSTRING), "CmnDlg_callback" )

	return DllCall("comdlg32\FindTextA", "str", FR)
}

CmnDlg_callback(wparam, lparam, msg, hwnd) {
	global CmnDlg_Event, CmnDlg_Flags, CmnDlg_FindWhat, CmnDlg_ReplaceWith
	static FR_DIALOGTERM = 0x40, FR_DOWN=1, FR_MATCHCASE=4, FR_WHOLEWORD=2, FR_HIDEMATCHCASE=0x8000, FR_HIDEWHOLEWORD=0x10000, FR_HIDEUPDOWN=0x4000, FR_REPLACE=0x10, FR_REPLACEALL=0x20, FR_FINDNEXT=8
	static fun 

	if (hwnd = "")
		return fun := wparam

	flags := NumGet(lparam+0, 12), CmnDlg_Flags := "" 
	if (flags & FR_DIALOGTERM) {
		CmnDlg_Event := "close"
		gosub %fun%
		return
	}


	CmnDlg_Flags .= (Flags & FR_MATCHCASE) && !(Flags & FR_HIDEMATCHCASE)? "c" :
	CmnDlg_Flags .= (Flags & FR_WHOLEWORD) && !(Flags & FR_HIDEWHOLEWORD) ? "w" :
	CmnDlg_FindWhat := DllCall("MulDiv", "Int", NumGet(lparam+0, 16), "Int",1, "Int",1, "str") 

	if (flags & FR_FINDNEXT) {
		CmnDlg_Event := "find"
		CmnDlg_Flags .= (Flags & FR_DOWN) && !(Flags & FR_HIDEUPDOWN) ? "d" :
		gosub %fun%
		return 
	}

	if (flags & FR_REPLACE) or (flags & FR_REPLACEALL) {
		CmnDlg_Event := (flags & FR_REPLACEALL) ? "replace_all" : "replace"
		CmnDlg_ReplaceWith := DllCall("MulDiv", "Int", NumGet(lparam+0, 20), "Int",1, "Int",1, "str") 
		gosub %fun%
		return 
	}
}

SetColors(hEdit) {
	colors=
	(
		Text				= 0
		Back				= 0xFFFFFF
		SelText				= 0xFFFFFF
		ActSelBack			= 0xc56a31
		InSelBack			= 0xAAAAAA
		LineNumber			= 0x0
		SelBarBack			= 0xFFCCCC
		NonPrintableBack	= 0xFFFFFF
		Number				= 0x0000FF
	)
	HE_SetColors(hEdit, colors )								
}

OnHiEdit:
	OutputDebug % HE_EVENT " | " HE_INFO
return

GoToLine() {
	global hEdit

	cnt := HE_GetLineCount(hEdit)
	InputBox, line, Go To Line, Enter line (1 - %cnt%), , 200, 120
	if ErrorLevel
		return
	if line > cnt
		line := cnt

	line_idx := HE_LineIndex(hEdit, line-1)
	HE_SetSel( hEdit, line_idx, line_idx)
	HE_ScrollCaret(hEdit )
}

FindNext( hEdit ){
	global CmnDlg_FindWhat

	if (CmnDlg_FindWhat = "")
		return
	gosub OnFind
}


OnFind:
{
	StringReplace, CmnDlg_Flags, CmnDlg_Flags, d,
	StringReplace, CmnDlg_Flags, CmnDlg_Flags, c, MATCHCASE%A_SPACE%
	StringReplace, CmnDlg_Flags, CmnDlg_Flags, w, WHOLEWORD%A_SPACE%


	res := HE_FindText(hEdit, CmnDlg_FindWhat, HE_GetSel(hEdit)+ (res!="")*1, -1, CmnDlg_Flags)
	HE_SetSel(hEdit, res, res + StrLen(CmnDlg_FindWhat))
	HE_ScrollCaret(hEdit)
	return
}

Anchor(c, a = "", r = false) { ; v3.6 - Titan
	static d
	GuiControlGet, p, Pos, %c%
	If ex := ErrorLevel {
		Gui, %A_Gui%:+LastFound
		ControlGetPos, px, py, pw, ph, %c%
	}
	If !(A_Gui or px) and a
		Return
	i = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%.`n%A_Gui%:%c%=
	StringSplit, i, i, .
	d := a ? d . ((n := !InStr(d, i9)) ? i9 : "")
		: RegExReplace(d, "\n\d+:" . c . "=[\-\.\d\/]+")
	Loop, 4
		x := A_Index, j := i%x%, i6 += x = 3
		, k := !RegExMatch(a, j . "([\d.]+)", v) + (v1 ? v1 : 0)
		, e := p%j% - i%i6% * k, d .= n ? e . i5 : ""
		, RegExMatch(d, "\Q" . i9 . "\E(?:([\d.\-]+)/){" . x . "}", v)
		, l .= p%j% := InStr(a, j) ? (ex ? "" : j) . v1 + i%i6% * k : ""
	If r
		rx = Draw
	If ex
		ControlMove, %c%, px, py, pw, ph
	Else GuiControl, Move%rx%, %c%, %l%
}

9GuiSize:
8GuiSize:
  Anchor("HiEdit1", "wh")
return

HE_Add(hwnd, x, y, w, h, style="HSCROLL VSCROLL", dllPath="HiEdit.dll"){
	global HE_MODULEID													
	static WS_CLIPCHILDREN=0x2000000, WS_VISIBLE=0x10000000, WS_CHILD=0x40000000													
	static HSCROLL=0x8 ,VSCROLL=0x10, TABBED=4, HILIGHT=0x20, TABBEDBTOP=0x1, TABBEDHRZSB=0x2 ,TABBEDBOTTOM=0x4, SINGLELINE=0x40, FILECHANGEALERT=0x80													

	hStyle := 0													
	loop, parse, style, %A_Tab%%A_Space%													
	{													
		IfEqual, A_LoopField, , continue												
		hStyle |= %A_LOOPFIELD%												
	}													

	if !init {													
		HE_MODULEID := 1020												
		DllCall("LoadLibrary", "str", dllPath)												
		init := true 												
	}													

	hCtrl := DllCall("CreateWindowEx"													
      , "Uint", 0x200            ; WS_EX_CLIENTEDGE
      , "str",  "HiEdit"         ; ClassName
      , "str",  szAppName      ; WindowName
      , "Uint", WS_CLIPCHILDREN | WS_CHILD | WS_VISIBLE | hStyle
      , "int",  x            ; Left
      , "int",  y            ; Top
      , "int",  w            ; Width
      , "int",  h            ; Height
      , "Uint", hwnd         ; hWndParent
      , "Uint", HE_MODULEID  ; hMenu
      , "Uint", 0            ; hInstance
      , "Uint", 0)
	HE_SetTabsImageList(hCtrl)													
	return hCtrl													
}

HE_AutoIndent(hEdit, pState ) {
	static HEM_AUTOINDENT := 2042		;wParam=0,	lParam=fAutoIndent:TRUE/FALSE										
	SendMessage, HEM_AUTOINDENT, 0, pState,, ahk_id %hEdit%													
	return errorlevel													
}

HE_CloseFile(hEdit, idx=-1){
	static HEM_CLOSEFILE	:= 2026		;wParam=0,										
	SendMessage, HEM_CLOSEFILE, 0, idx,, ahk_id %hEdit%													
	return errorlevel													
}

HE_ConvertCase(hEdit, case="toggle") {
	static HEM_CONVERTCASE=2046		;EQU WM_USER+1022	;wParam=CC_UPPERCASE/CC_LOWERCASE/CC_TOGGLECASE,lParam = -1	 :Returns TRUE if successful/FALSE otherwise									
	static cc_upper=0, cc_lower=1, cc_toggle=2, cc_capitalize=3													
	SendMessage, HEM_CONVERTCASE, cc_%case%, -1,, ahk_id %hEdit% 													
	Return ErrorLevel													
}

HE_FindText(hEdit, sText, cpMin=0, cpMax=-1, flags="") { 
	static EM_FINDTEXT=1080,WHOLEWORD=2,MATCHCASE=4		 ;WM_USER + 56											
	hFlags := 0													
	loop, parse, flags, %A_Tab%%A_Space%,%A_Space%%A_Tab%													
		if (A_LoopField != "")												
			hFlags |= %A_LOOPFIELD%											
	VarSetCapacity(FT, 12)													
	NumPut(cpMin,  FT, 0)													
	NumPut(cpMax,  FT, 4)													
	NumPut(&sText, FT, 8)													
	SendMessage, EM_FINDTEXT, hFlags, &FT,, ahk_id %hEdit% 													
	Return ErrorLevel 													
}

HE_GetColors(hEdit){
	static HEM_GETCOLORS := 2038													
	static names := "Text,Back,SelText,ActSelBack,InSelBack,LineNumber,SelBarBack,NonPrintableBack,Number"													
	VarSetCapacity(COLORS, 48, 0)													
	SendMessage,HEM_GETCOLORS,0,&COLORS,,ahk_id %hEdit%													
	ifEqual,ErrorLevel,FAIL, return FAIL													
	fmt := A_FormatInteger													
	SetFormat, integer, hex													
	Loop, Parse, names, `,													
		res .= A_LoopField "=" NumGet(COLORS, 4*(A_Index-1)) "`n"												
	SetFormat,  integer, %fmt%													
	return SubStr(res, 1, -1)													
}

HE_GetCurrentFile(hEdit){
	static HEM_GETCURRENTFILE	:= 2032	;wParam=0,			lParam = 0								
	SendMessage, HEM_GETCURRENTFILE, 0, 0,, ahk_id %hEdit%													
	return errorlevel													
}

HE_GetFileCount(hEdit){
	static HEM_GETFILECOUNT	:= 2029			;wParam=0,	lParam=0								
	SendMessage, HEM_GETFILECOUNT, 0, 0,, ahk_id %hEdit%													
	return errorlevel													
}

HE_GetFileName(hEdit, idx=-1){
	static HEM_GETFILENAME		:= 2030		;wParam = lpszFileName, lParam = -1 for current file or dwFileIndex	:Returns TRUE if successful/FALSE otherwise								
	VarSetCapacity(fileName, 512)													
	SendMessage, HEM_GETFILENAME, &fileName, idx,, ahk_id %hEdit%													
	return fileName													
}

HE_GetFirstVisibleLine(hEdit){
	static EM_GETFIRSTVISIBLELINE=206													
	SendMessage, EM_GETFIRSTVISIBLELINE, 0, 0,, ahk_id %hEdit% 													
	Return ErrorLevel 													
}

HE_GetLine(hEdit, idx=-1){
	static EM_GETLINE=196	  ;The return value is the number of characters copied. The return value is zero if the line number specified by the line parameter is greater than the number of lines in the HiEdit control												
	if (idx = -1) 													
		idx := HE_LineFromChar(hEdit, HE_LineIndex(hEdit))												
	len := HE_LineLength(hEdit, idx)													
	VarSetCapacity(txt, len), NumPut(len, txt)													
	SendMessage, EM_GETLINE, idx, &txt,, ahk_id %hEdit% 													
	if ErrorLevel = 0													
		return												
	VarSetCapacity(txt, -1)													
	Return SubStr(txt, 1, ErrorLevel)													
}

HE_GetLineCount(hEdit){
	static EM_GETLINECOUNT=186													
   	SendMessage, EM_GETLINECOUNT, 0, 0,, ahk_id %hEdit%													
	Return ErrorLevel													
}

HE_GetRedoData(hEdit, level){
	static HEM_GETREDODATA=2040		;wParam=Undo level (1 based),	lParam=lpUNDODATA	:Returns type of undo (UNDONAMEID)									
	static UID_0="UNKNOWN",UID_1="TYPING",UID_2="DELETE",UID_3="DRAGDROP",UID_4="CUT",UID_5="PASTE",UID_6="SETTEXT",UID_7="REPLACESEL",UID_8="CLEAR",UID_9="BACKSPACE",UID_10="INDENT",UID_11="OUTDENT",UID_12="CODEPAGE",UID_13="CASE"													
	static size = 128													
	VarSetCapacity( RD, 8, 0), VarSetCapacity( buf, size ), NumPut(&buf, RD), NumPut(size, RD, 4)													
	SendMessage, HEM_GETREDODATA, level, &RD,, ahk_id %hEdit%													
	VarSetCapacity(buf, -1)													
	Return % UID_%ErrorLevel%													
}

HE_GetSel(hEdit, ByRef start_pos="@",ByRef end_pos="@"){
	static EM_GETSEL=176													

	VarSetCapacity(s, 4), VarSetCapacity(e, 4)													
	SendMessage, EM_GETSEL, &s, &e,, ahk_id %hEdit% 													
	s := NumGet(s), e := NumGet(e)													
	if (start_pos != "@")													
		start_pos := s												
	if (end_pos != "@")													
		end_pos := e												

	Return s													
}

HE_GetSelText(hEdit){
	static EM_GETSELTEXT = 1086		;Returns: the number of characters copied, not including the terminating null character.											
	HE_GetSel(hEdit, s, e),	VarSetCapacity(buf, e-s+2)												
	SendMessage, EM_GETSELTEXT, 0, &buf,, ahk_id %hEdit% 													
	VarSetCapacity(buf, -1)													
	Return buf													
}

HE_GetTextLenght(hEdit) {
	static WM_GETTEXTLENGTH=14													
	SendMessage, WM_GETTEXTLENGTH, 0, 0,, ahk_id %hEdit% 													
	Return ErrorLevel 													
}

HE_GetTextRange(hEdit, min=0, max=-1){
	static EM_GETTEXTRANGE=1099			;Returns: The number of characters copied, not including the terminating null character.										
	if (max=-1)													
		max := HE_GetTextLenght(hEdit)												
	VarSetCapacity(buf, max-min+2)													
	VarSetCapacity(RNG, 12), NumPut(min, RNG), NumPut(max, RNG, 4), NumPut(&buf, RNG, 8)													
	SendMessage, EM_GETTEXTRANGE, 0, &RNG,, ahk_id %hEdit% 													
	VarSetCapacity(buf, -1)													
	Return buf													
}

HE_GetUndoData(hEdit, level){
	static HEM_GETUNDODATA=2039		;wParam=Undo level (1 based),	lParam=lpUNDODATA	:Returns type of undo (UNDONAMEID)									
	static UID_0="UNKNOWN",UID_1="TYPING",UID_2="DELETE",UID_3="DRAGDROP",UID_4="CUT",UID_5="PASTE",UID_6="SETTEXT",UID_7="REPLACESEL",UID_8="CLEAR",UID_9="BACKSPACE",UID_10="INDENT",UID_11="OUTDENT",UID_12="CODEPAGE",UID_13="CASE"													
	static size = 128													
	VarSetCapacity( UD, 8, 0), VarSetCapacity( buf, size ), NumPut(&buf, UD), NumPut(size, UD, 4)													
	SendMessage, HEM_GETUNDODATA, level, &UD,, ahk_id %hEdit%													
	VarSetCapacity(buf, -1)													
	Return % UID_%ErrorLevel%													
}



HE_LineFromChar(hEdit, ich) {
	static EM_LINEFROMCHAR=201													
   	SendMessage, EM_LINEFROMCHAR, ich, 0,, ahk_id %hEdit%													
	Return ErrorLevel													
}

HE_LineIndex(hedit, idx=-1) {
	static EM_LINEINDEX=187													
 	SendMessage, EM_LINEINDEX, idx, 0,, ahk_id %hEdit% 													
	Return ErrorLevel													
}

HE_LineLength(hEdit, idx=-1) {
	static EM_LINELENGTH=193													
	SendMessage, EM_LINELENGTH, He_LineIndex(hEdit, idx) , 0,, ahk_id %hEdit% 													
	Return ErrorLevel													
}

HE_LineNumbersBar( hEdit, state="show", linw=40, selw=10 ) {
	static HEM_LINENUMBERSBAR := 2036		;EQU WM_USER+1012		;wParam=LNB_HIDE/LNB_SHOW/LNB_AUTOSIZE,			lParam=HIWORD:Selection bar width , LOWWORD:Line numbers width						
	static LNB_HIDE=0, LNB_SHOW=1, LNB_AUTOMAXSIZE=2, LNB_AUTOSIZE=4													

	if state is not Integer													
		state := LNB_%state%												
	SendMessage, HEM_LINENUMBERSBAR,state,selw<<16 | linw,,ahk_id %hEdit%													
	return errorlevel													
}

HE_NewFile(hEdit){
	static HEM_NEWFILE	:= 2024		;wParam=0,	lParam=0									
	SendMessage, HEM_NEWFILE, 0, 0,, ahk_id %hEdit%													
	return errorlevel													
}

HE_OpenFile(hEdit, pFileName, flag=0){
	static HEM_OPENFILE	:= 2025		;wParam=0,				lParam=lpszFileName	 Returns TRUE if successful/FALSE otherwise					
	SendMessage, HEM_OPENFILE, flag, &pFileName,, ahk_id %hEdit%													
	return errorlevel													
}

HE_Redo(hEdit) { 
	static EM_REDO := 1108 													
	SendMessage, EM_REDO,,,, ahk_id %hEdit%    													
	return ErrorLevel													
} 
HE_ReloadFile(hEdit, idx=-1) {
	static HEM_RELOADFILE=2027	;EQU WM_USER+1003	;wParam=0,	lParam = -1 for current file										
	SendMessage, HEM_RELOADFILE, 0, idx,, ahk_id %hEdit% 													
	Return ErrorLevel 													
}

HE_ReplaceSel(hEdit, text=""){
	static  EM_REPLACESEL=194													

	SendMessage, EM_REPLACESEL, 0, &text,, ahk_id %hEdit% 													
	Return ErrorLevel													
}

HE_SaveFile(hEdit, pFileName, idx=-1){
	static HEM_SAVEFILE	:= 2028		;wParam=lpszFileName,					lParam = -1 for current file or dwFileIndex	:Returns 				

	SendMessage, HEM_SAVEFILE, &pFileName, idx,, ahk_id %hEdit%													
	return errorlevel													
}

HE_ScrollCaret(hEdit){
	static EM_SCROLLCARET=183													
	SendMessage, EM_SCROLLCARET, 0, 0,, ahk_id %hEdit% 													
	Return ErrorLevel													
}

HE_SetColors(hEdit, colors, fRedraw=true){
	static HEM_SETCOLORS := 2037													
	static names := "Text,Back,SelText,ActSelBack,InSelBack,LineNumber,SelBarBack,NonPrintableBack,Operator,Number,Comment,String"													
	at := A_AutoTrim													
	AutoTrim,  on													
    Loop, Parse, colors, `n, `n
	{													
		name := SubStr(A_LoopField, 1, i:=InStr(A_LoopField, "=")-1),  val := SubStr(A_LoopField, i+2)												
		name = %name%												
		val = %val%												
		if name not in %names%												
			return "Invalid color name: '" name "'"											
		if val is not Integer												
			return "Invalid color value: '" val "'"											
		n%name%	:= val											
	}													
	AutoTrim, %at%													
	VarSetCapacity(COLORS, 36, 0)													
	NumPut(nText			, COLORS, 0)	;NormalTextColor									
	NumPut(nBack			, COLORS, 4) 	;EditorBkColor									
	NumPut(nSelText			, COLORS, 8) 	;SelectionForeColor									
	NumPut(nActSelBack		, COLORS, 12)	;ActiveSelectionBkColor										
	NumPut(nInSelBack		, COLORS, 16)	;InactiveSelectionBkColor										
	NumPut(nLineNumber		, COLORS, 20)	;LineNumberColor										
	NumPut(nSelBarBack		, COLORS, 24)	;SelBarBkColor   										
	NumPut(nNonPrintableBack, COLORS, 28)	;NonPrintableBackColor		   										
	NumPut(nNumber			, COLORS, 32)	;NumberColor									
	SendMessage,HEM_SETCOLORS, &COLORS, fRedraw,,ahk_id %hEdit%													
	return ErrorLevel													
}

HE_SetCurrentFile(hEdit, idx){
	static HEM_SETCURRENTFILE	:= 2033		;wParam=0,	lParam = dwFileIndex									
	SendMessage, HEM_SETCURRENTFILE, 0, idx,, ahk_id %hEdit%													
	return errorlevel													
}

HE_SetEvents(hEdit, func, e="selchange"){
	local old, hmask													
	static ENM_KEYEVENTS = 0x10000, ENM_MOUSEEVENTS = 0x20000, ENM_SCROLLEVENTS = 0x8, ENM_SELCHANGEEVENTS = 0x80000, ENM_CONTEXTMENUEVENTS=0x20													
	static EM_SETEVENTMASK = 1093, events="key,mouse,scroll,selchange,contextmenu"													

	if !IsLabel(func)													
		return "Err: label doesn't exist`n`n" func												

	hmask := 0													
	loop, parse, e, %A_Tab%%A_Space%													
	{													
		IfEqual, A_LoopField, , continue												
		if A_LoopField not in %events%												
			return "Err: unknown event - '" A_LoopField "'"											
		hmask |= ENM_%A_LOOPFIELD%EVENTS												
	}													
	SendMessage, EM_SETEVENTMASK, 0, hMask,, ahk_id %hEdit%													

	old := OnMessage(0x4E, "HE_onNotify")													
	if (old != "HE_onNotify")													
		HE_oldNotify := RegisterCallback(old)												

	hEdit += 0													
	HE_%hEdit%_func	 := func												
	return "OK"													
}


HE_onNotify(wparam, lparam, msg, hwnd) {
	local code, hw, idFrom, m, l, w													
	static EN_TABMCLICK=0x1000, EN_FILECHANGE=0x1001, EN_SELCHANGE = 0x702, EN_MSGFILTER = 0x700													

	idFrom :=  NumGet(lparam+4)   ; and its ID 													
	if (idFrom != HE_MODULEID)													
		return HE_oldNotify ? DllCall(HE_oldNotify, "uint", wparam, "uint", lparam, "uint", msg, "uint", hwnd) : ""												

	hw	   :=  NumGet(lparam+0)   ;control sending the message - this HiEdit												
	code   :=  NumGet(lparam+8)		;- 4294967296											

    HE_HWND := hw
	HE_EVENT := HE_INFO := ""													
	if (code = EN_TABMCLICK) {													
		HE_EVENT := "tabmclick"												
		GoSub % HE_%hw%_func												
		return												
	}													

	if (code = EN_FILECHANGE) {													
		HE_EVENT := "filechange", HE_INFO := NumGet(lparam+12)												
		GoSub % HE_%hw%_func												
		return												
	}													

	if (code = EN_SELCHANGE) {													
		HE_EVENT := "selchange",  m := NumGet(lparam+20, 0, "Short")=16,  l := NumGet(lparam+30) && !m												
		HE_INFO := "S" NumGet(lparam+12) " E" NumGet(lparam+16) " L" NumGet(lparam+22)  (m ? " t" : "") (l ? " *" : "")												
		GoSub % HE_%hw%_func												
		return												
	}													

	if (code=EN_MSGFILTER) {													
		m := NumGet(lparam+12), w := NumGet(lparam+16), l := NumGet(lparam+20)												
		if m between 0x201 AND 0x209	;mouse messges, don't report WM_MOUSEMOVE=0x200											
			 HE_EVENT := "mouse", HE_INFO := "x" l & 0xFFFF " y" (l >> 16) " v" w											
		else if m = 0x102				;WM_CHAR								
			 HE_EVENT := "key", HE_INFO := chr(w)											
		else if m = 0x7B				; WM_CONTEXTMENU 								
			 HE_EVENT := "contextmenu"											
		else if m = 0x20A				 ;WM_MOUSEWHEEL								
			 HE_EVENT := "scroll"											

		if HE_EVENT												
			GoSub % HE_%hw%_func											
		return												
	}													
}

HE_SetFont(hEdit, pFont="") { 
   local height, weight, italic, underline, strikeout , nCharSet 
   local hFont, LogPixels
   static WM_SETFONT := 0x30
   italic      := InStr(pFont, "italic")    ?  1    :  0 
   underline   := InStr(pFont, "underline") ?  1    :  0 
   strikeout   := InStr(pFont, "strikeout") ?  1    :  0 
   weight      := InStr(pFont, "bold")      ? 700   : 400 
   RegExMatch(pFont, "(?<=[S|s])(\d{1,2})(?=[ ,])", height) 
   if (height = "") 
      height := 10 
   RegRead, LogPixels, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI, LogPixels 
   height := -DllCall("MulDiv", "int", Height, "int", LogPixels, "int", 72) 
   RegExMatch(pFont, "(?<=,).+", fontFace)    
   if (fontFace != "") 
       fontFace := RegExReplace( fontFace, "(^\s*)|(\s*$)")      ;trim 
   else fontFace := "MS Sans Serif" 
   hFont   := DllCall("CreateFont", "int",  height, "int",  0, "int",  0, "int", 0 
                      ,"int",  weight,   "Uint", italic,   "Uint", underline 
                      ,"uint", strikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", fontFace) 
   SendMessage,WM_SETFONT,hFont,TRUE,,ahk_id %hEdit%
   return ErrorLevel
}

HE_SetKeywordFile( pFile ){
	return DllCall("HiEdit.dll\SetKeywordFile", "str", pFile)													
}

HE_SetSel(hEdit, nStart=0, nEnd=-1) {
	static EM_SETSEL=0x0B1													
	SendMessage, EM_SETSEL, nStart, nEnd,, ahk_id %hEdit% 													
	Return ErrorLevel 													
}

HE_SetTabWidth(hEdit, pWidth, pRedraw=true){
	static HEM_SETTABWIDTH := 2041		;wParam=nChars,		lParam=fRedraw:TRUE/FALSE									
	SendMessage, HEM_SETTABWIDTH, pWidth, pRedraw,, ahk_id %hEdit%													
	return errorlevel													
}

HE_SetTabsImageList(hEdit, pImg="") {
	static LR_LOADFROMFILE		:= 0x10											
		,  LR_CREATEDIBSECTION	:= 0x2000											
		,  HEM_SETTABSIMAGELIST := 2043												
		,  toolbarBMP			:= "424de60000000000000076000000280000001c00000007000000010004000000000070000000000000000000000010000000000000000000000000008000008000000080800080000000800080008080000080808000c0c0c0000000ff0000ff000000ffff00ff000000ff00ff00ffff0000ffffff00fddddfdddddfdddfdddddfddddfd0000fdddffddddffdddffddddffdddfd0000fddfffdddfffdddfffdddfffddfd0000fdffffddffffdddffffddffffdfd0000fddfffdddfffdddfffdddfffddfd0000fdddffddddffdddffddddffdddfd0000fddddfdddddfdddfdddddfddddfd0000"									
	if (pImg = "")	{												
		deleteFile := true												
		pImg := "___he_bar.bmp"												
		WriteFile(pImg, toolbarBMP)												
	}													
	hImlTabs := DllCall("comctl32.dll\ImageList_LoadImage", "uint", 0													
			, "str", pImg											
			, "int", 7, "int", 4											
			, "uint", 0x0FF00FF											
			, "uint", IMAGE_BITMAP											
			, "uint", LR_CREATEDIBSECTION | LR_LOADFROMFILE )											
	if (deleteFile) 													
		FileDelete, %pImg%												
	SendMessage,HEM_SETTABSIMAGELIST,0,hImlTabs,,ahk_id %hEdit%													
}

HE_ShowFileList(hEdit, x=0, y=0){
	static HEM_SHOWFILELIST	:= 2044	    ;EQU WM_USER+1020		;wParam=X pos,									lParam=Y pos
	SendMessage, HEM_SHOWFILELIST, x, y,, ahk_id %hEdit%													
}

HE_Undo(hEdit) { 
	static WM_UNDO := 772 													
	SendMessage, WM_UNDO,,,, ahk_id %hEdit% 													
	return ErrorLevel													
}


WriteFile(file,data) { 
   Handle :=  DllCall("CreateFile","str",file,"Uint",0x40000000 ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0) 
   Loop{ 
     if strlen(data) = 0 
        break 
     StringLeft, Hex, data, 2          
     StringTrimLeft, data, data, 2  
     Hex = 0x%Hex% 
     DllCall("WriteFile","UInt", Handle,"UChar *", Hex ,"UInt",1,"UInt *",UnusedVariable,"UInt",0) 
   } 
 
   DllCall("CloseHandle", "Uint", Handle) 
   return 
}




;______________________________________
;#Include en.decryption.txt
1Include_en_decryption:
Return
Encrypt(ByRef passwordchecking, ByRef config){
		Transform, ms, Chr, 3
		Transform, ps, Chr, 2
		SetFormat, Float, 0
		Stringlen, encryptvarinlength , passwordchecking
		;MsgBox, länge %encryptvarinlength%
		count = 0
		Loop
		{
			If count > %encryptvarinlength%
			{
			StringTrimRight, FileName, FileName, 3
			FileName = %FileName%`.%currentrandomencryptnumber%
			break
			}
			Random, randomnumber%count%, 0, 99999999
			If (randomnumber%count% < 99999999 and randomnumber%count% > 9999999)
			{
			currentrandomencryptnumber := randomnumber%count%
			Filename = %filename%%currentrandomencryptnumber%
			count++
			}
		}
		FileDelete, %Filename%
		StringSplit, pwcount, passwordchecking
		;count -= 1
		randomnumberspecial = %currentrandomencryptnumber%
		;MsgBox, pwcount %pwcount0% currentrandomnumber %randomnumberspecial% fileend: %currentrandomencryptnumber%
		pwcounted =
		count = 1
		count2 = 0
		passwordchecking =
		Loop, %pwcount0%
		{
			pwcounting =
			pwtocount := pwcount%count%
			Transform, pwcounting, Asc, %pwtocount%
			;MsgBox, Buchstabennummer:%pwcounting%`nbuchstabe: %pwtocount%
			randomnumbercount := randomnumber%count2%
			pwcounting *= randomnumbercount
			;MsgBox, buchstabennumer: %pwcounting% `nmal`n Randomnumber: %randomnumbercount%
			pwcounting *= %randomnumberspecial%
			;MsgBox, buchstabennumer neu: %pwcounting% `nmal`n Randomnumber: %randomnumberspecial%
			Stringlen, pwcountinglength, pwcounting
			pwcountinglength -= 19
			StringTrimLeft, pwcountinglength, pwcountinglength, 1
			;MsgBox, wert + length %pwcounting% %pwcountinglength%
			Loop, %pwcountinglength%
			{
				pwcounting = 0%pwcounting%
			}
					;MsgBox, %pwcounting%
			encryptvarout = %encryptvarout%%pwcounting%
			;MsgBox, %encryptvarout%
			count++
			count2++
		}
		FileAppend, %encryptvarout%, %Filename%
		Sleep, 10
		FileDelete, %config%
		FileAppend, `[DEFAULT`]`nF93DHH98E08776AC=%Filename%`ndefaultprofile =DEFAULT`nsetdebugger=TO USE DEBUGGER ENTER ON ELSE OFF|USE PARAMETERS TO ENTER SLEEP SPEED IN MILISECONDS%ps%OFF%ps%0`nsetautostart=TO USE AUTO START PLEASE ENTER ON | OFF | ASK%ps%ASK`nsetwebbrowser =Internet Explorer ! DO NOT DELETE THIS KEY !ENTER HERE YOUR STANDART BROWSER!%ps%%A_ProgramFiles%\Internet Explorer\iexplore.exe`nsetmouse=ENTER KEYsMOUSE SPEED|ACCELLERATIONSPEED - E.G. 5|2.5%ps%5|2`nsetwinwatcher=ENTER SPEED IN SECONDS HOW OFTEN TO UPDATE WINWATCHER%ps%2`np=OPEN FOLDER PROGRAMS CAPSLOCKp HOTKEYpr%ps%C:\Program Files\`nnotepad=NOTEPAD CAPSLOCKn%ps%%A_WinDir%\Notepad.exe`ndemo=DEMO AUTOSTART%ps%ToolTip`,`,`,`,20%ms%MsgBox`, 4`, DEMO`, SHOW DEMO%ms%IfMsgBox`, No`, Return%ms%InputBox`, username`, NAME`, WHAT IS YOUR NAME`, `,200`, 150`,`,`,`,`,%A_USERNAME%%ms%BlockInput`, On%ms%Run`, %A_windir%\notepad.exe%ms%WinWaitActive`, AHK_class Notepad%ms%Sleep`, 500%ms%[Hallo ]%ms%Send`, `%username`%%ms%[{ENTER 2}]%ms%Sleep`, 500%ms%[WELCOME TO ]%ms%Send`,`%SCRIPTNAME_VAR`%%ms%[`.{ENTER 2}]%ms%Sleep`, 1000%ms%[DO YOU FEEL IT IS OFTEN TO COMPLEX TO USE COMPUTER{ENTER 2}]%ms%Sleep`, 3000%ms%[NOW YOU CAN SPEED UP YOUR WORK INCREDIBLE{ENTER 2}]%ms%Sleep`, 3000%ms%[WITH ]%ms%Send`, `%SCRIPTNAME_VAR`%%ms%[ YOU HAVE 2 WAYS TO START YOUR PROGRAM`, WEBSITE OR COMMAND{ENTER 2}]%ms%Sleep`, 3000%ms%[ IT IS VERY EASY TO SET UP A NEW COMMAND AND ALSO INCREADIBLE FAST{ENTER 2}]%ms%Sleep`, 3000%ms%[TRY IT{ENTER} - FIRST YOU CAN TRY THE MASTER FUNCTIONS LIKE OPENING A WEBSITE{ENTER}]%ms%Sleep`, 4000%ms%[ - OPEN THE ]%ms%Send`, `%SCRIPTNAME_VAR`%%ms%[ BY PRESSING CAPSLOCK & TAB (A tooltip message will be displayed)]%ms%Sleep`, 4000%ms%[{ENTER} - ENTER YOUR WEBSITE EXCLUDING www.*.com`, FOR EXAMPLE google TYPE NOW{ENTER 2}]%ms%Sleep`, 1000%ms%BlockInput`, Off%ms%GoSub`, Eingabe_Starten%ms%seconds=10, %config%
		FileAppend, %ms%Loop`, 10%ms%{%ms%	EnvSub`, seconds`, 1%ms%	ToolTip`, Program will continue in `%seconds`% seconds`,`,`,20%ms%	Sleep`, 1000%ms%}%ms%ToolTip`,`,`,`,20%ms%BlockInput`, On%ms%WinActivate`, AHK_class Notepad%ms%Sleep`, 500%ms%[YOU CAN CALCULATE BY ADDING = TO YOUR ENTRY IN FRONT`, e.g. =5]%ms%SendRaw`, +%ms%[5{ENTER 2}]%ms%Sleep`, 3000%ms%[SEARCH ON GOOGLE BY ENTERING . IN FRONT OF YOUR ENTRY E.G. .book amazon{Enter 2}]%ms%Sleep`, 3000%ms%BlockInput`, Off%ms%MsgBox`, 4`, Continue?%ms%IfMsgBox`, No`, WinClose`, AHK_class Notepad%ms%IfMsgBox`, No`, MsgBox`, IF YOU WANT TO RUN DEMO AGAIN TYPE DEMO AFTER PRESSING CAPSLOCK & TAB%ms%IfMsgBox`, No`, break%ms%Sleep`, 500%ms%BlockInput`, On%ms%Send`, NOW LETS GET INTO DETAIL{ENTER 2}%ms%Sleep`, 3000%ms%Send`, LETS LOOK AT THE MANAGEMENT OF YOUR MACROS{ENTER 2}%ms%Sleep`, 3000%ms%Send`, TO OPEN THE GUI`, PRESS CAPSLOCK & F5`, FOLLOWING WINDOW WILL APPEAR{ENTER 2}%ms%Sleep`, 5000%ms%GoSub`, Macrokeys%ms%WinWaitActive`, `%SCRIPTNAME_VAR`% MACRO MANAGEMENT%ms%Sleep`, 2000%ms%MouseMove`, 179 `, 371%ms%Click`, 2%ms%ToolTip`, HERE YOU MUST ENTER THE KEYWORD FOR EXAMPLE g`,`,`,20%ms%Sleep`, 5000%ms%MouseMove`, 280 `, 395`, 50%ms%ToolTip`, HERE YOU CAN ENTER THE LONG NAME. USE CAPSLOCK/SCROLLLOCK/NUMLOCK+CHARACTER OR HOTKEY+CHARACTER+CHARACTER TO ACTIVATE HOTKEYS`,`,`,20%ms%Sleep`, 8000%ms%MouseMove`, 351 `, 469`, 50%ms%ToolTip`, HERE YOU MUST ENTER FOLDER/FILE OR YOUR MACRO`,`,`,20%ms%Sleep`, 5000%ms%MouseMove`, 107 `, 326`, 50%ms%ToolTip`, CLICK HERE TO SAVE YOUR MACRO`,`,`,20%ms%Sleep`, 5000%ms%MouseMove`, 143 `, 686`, 50%ms%Click`, 143 `, 686%ms%ToolTip`, HERE YOU CAN GET HELP ABOUT COMMANDS`,`,`,20%ms%Send`, StringLeft%ms%Sleep`, 6000%ms%ToolTip`,`,`,`,20%ms%BlockInput`, Off%ms%WinClose`, `%SCRIPTNAME_VAR`% MACRO MANAGEMENT%ms%WinClose`, AHK_class Notepad%ms%WinWait`, AHK_class #32770%ms%WinActivate`, AHK_class #32770%ms%WinWaitActive`, AHK_class #32770%ms%Send`, !n%macroseparator%MsgBox`, IF YOU WANT TO RUN DEMO AGAIN TYPE DEMO AFTER PRESSING CAPSLOCK & TAB, %config%
		Sleep, 10
		FileSetAttrib, +RS, %Filename%
		Sleep, 10
		FileSetAttrib, +S, %config%
		Sleep, 10
		FileDelete, %FileName%
		SetFormat, Float, 0.16
		Return
}

Decrypt(ByRef passwordchecking, ByRef config){
		SetFormat, Float, 0
		Stringsplit, passwordchecking, passwordchecking
		IniRead, pwchkcounted, %config%, DEFAULT, F93DHH98E08776AC, ERROR
		StringRight, randomnumberspecial, pwchkcounted, 8
		StringTrimRight, pwcode, pwchkcounted, 8
		Stringlen, pwlength, pwcode
		pwlength /= 8
		count = 1
		Loop
		{	
			StringLeft, pwcode%count%, pwcode, 8
			StringTrimleft, pwcode, pwcode, 8
			If pwcode%count% =
			break
			count++
		}
		;MsgBox, %pwchkcounted%, %pwlength%, codes %pwcode1% %pwcode2% %pwcode3% %pwcode4%
		FileRead, 	pwfilecode, %pwchkcounted%
		;StringSplit, pwchkcount, pwfilecode, %A_Space%, %A_Space%
		pwchkcount0 =
		Loop
		{
			StringLeft, pwchkcount%A_Index%, pwfilecode, 19
			pwchkcount0++
			StringTrimLeft, pwfilecode, pwfilecode, 19
			If pwfilecode =
			break			
		}
		;MsgBox, code %pwfilecode% count %pwchkcount1%
		Loop, %pwchkcount0%
		{
			pwchkcounting =
			pwchkcounting := pwchkcount%A_Index%
			;MsgBox, random spec %randomnumberspecial% pwchk %pwchkcounting% pwcount %pwchkcount0% %pwchkcount1% %pwchkcount2% %pwchkcount3%
			pwchkcounting /= %randomnumberspecial%
			;MsgBox, key/spec: %pwchkcounting%
			pwchkcurrentkey := pwcode%A_Index%
			;MsgBox, key: %pwchkcurrentkey%
			pwchkcounting /= %pwchkcurrentkey%
			;MsgBox, erg/key: %pwchkcounting%
			Transform, pwchkcounting, Round, pwchkcounting
			Transform, pwchkcounting, Chr, %pwchkcounting%
			;MsgBox, buchstabe: 	%pwchkcounting%
			pwchkcountedout = %pwchkcountedout%%pwchkcounting%
		}
		SetFormat, Float, 0.16 
		passwordchecking = %pwchkcountedout%
		Return 
}

Encryptmakro(ByRef encryptmakrokeys, ByRef config){
		If encryptmakrokeys =
			Return
		SetFormat, Float, 0
		Stringlen, encryptvarinlength , encryptmakrokeys
		StringSplit, pwcount, encryptmakrokeys
		IniRead, filename, %config%, DEFAULT, F93DHH98E08776AC, ERROR
		If filename = ERROR
		Return
		Stringleft, filenamefirst, filename, 1
		If filenamefirst = `.
		{
		ToolTip, !!!VERSCHLÜSSELUNG OHNE PASSWORD NICHT MÖGLICH!!!, , ,20
		Sleep, 1000
		Return
		}
		FileRead, randomnumber, %filename%
		Stringsplit, randomnumber, randomnumber,, 0
		StringRight, randomnumberspecial, filename, 3
																																			;MsgBox, pwcount %pwcount0% special %randomnumberspecial%
		pwcounted =
		count2 = 1
		encryptmakrokeys =
		Loop, %pwcount0%
		{
			If randomnumber%count2% =
			count2 =1
			pwcounting =
			pwtocount := pwcount%A_Index%
			Transform, pwcounting, Asc, %pwtocount%
																																			;MsgBox, Buchstabennummer:%pwcounting%`nbuchstabe: %pwtocount% randomnumber %randomnumber%
			randomnumbercount := randomnumber%count2%
			pwcounting *= %randomnumbercount%
																																			;MsgBox, buchstabennumer1: %pwcounting% `nmal`n Randomnumber: %randomnumbercount%
			pwcounting *= %randomnumberspecial%
																																			;MsgBox, buchstabennumer neu: %pwcounting% `nmal`n Randomnumber: %randomnumberspecial%
			Stringlen, pwcountinglength, pwcounting
			pwcountinglength -= 7
			StringTrimLeft, pwcountinglength, pwcountinglength, 1
			Loop, %pwcountinglength%
			{
				pwcounting = 0%pwcounting%
			}
			encryptmakrokeys = %encryptmakrokeys%%pwcounting%
			count2++
		}
		SetFormat, Float, 0.16
		;MsgBox, end %encryptmakrokeys%
		Return
}

Decryptmakro(ByRef decryptmakrokeys, ByRef config){
		If decryptmakrokeys =
			Return
		;MsgBox % decryptmakrokeys
		SetFormat, Float, 0
		IniRead, pwchkfile, %config%, DEFAULT, F93DHH98E08776AC, ERROR
		FileRead, pwfilecode, %pwchkfile%
		StringRight, randomnumberspecial, pwchkfile, 3
		Stringsplit, pwcode, pwfilecode,, 0
		count = 1
		pwchkcount0 =
		Loop
		{
			If decryptmakrokeys =
			break			
			StringLeft, pwchkcount%A_Index%, decryptmakrokeys, 7
			pwchkcount0++
			StringTrimLeft, decryptmakrokeys, decryptmakrokeys, 7
		}
		;MsgBox % pwchkcount1
		count = 1
		Loop, %pwchkcount0%
		{
			If pwcode%count% =
			count = 1
			pwchkcounting =
			pwchkcounting := pwchkcount%A_Index%
																												;MsgBox, random spec %randomnumberspecial% pwchk %pwchkcounting% pwcount %pwchkcount0% %pwchkcount1% %pwchkcount2% %pwchkcount3%
			pwchkcounting /= %randomnumberspecial%
																												;MsgBox, key/spec: %pwchkcounting%
			pwchkcurrentkey := pwcode%count%
																												;MsgBox, key: %pwchkcurrentkey%
			pwchkcounting /= %pwchkcurrentkey%
																												;MsgBox, erg/key: %pwchkcounting%
			Transform, pwchkcounting, Round, pwchkcounting
			Transform, pwchkcounting, Chr, %pwchkcounting%
																												;MsgBox, buchstabe: 	%pwchkcounting%
			If pwchksaved = %A_Space%
			{
				pwchkcountedout = %pwchkcountedout%%A_Space%%pwchkcounting%
			}
			else
			{
				pwchkcountedout = %pwchkcountedout%%pwchkcounting%
			}
			pwchksaved := pwchkcounting
			count++
		}
																												;MsgBox % pwchkcountedout
		SetFormat, Float, 0.16
		StringRight, chkmakrokeyslast, pwchkcountedout, 3
		ToolTip, ENTER LAST 3 LETTERS OF YOUR ENTRY(MACRO),,,20
		Input, chkmakrokeys, L3 M, {ESC}
		;MsgBox % chkmakrokeyslast
		;MsgBox % pwchkcoundedout
		StringCaseSense, On
		If chkmakrokeys = %chkmakrokeyslast%
		{
			decryptmakrokeys = %pwchkcountedout%
			Sleep, 100
		}
		;MsgBox % pwchkcountedout
		StringCaseSense, Off
		StringRight, endkey, chkmakrokeyslast, 1
		KeyWait, %endkey%
		ToolTip,,,,20
		Return 
}







;________________________________
;#Include runvar.sendkeys.txt
1Include_runvar_sendkeys:
RunVar:
	RunVar()
Return

Runvar(){
	global
	local tooltipvar
	ToolTip,,,,20
	KeyWait, CAPSLOCK
	SetCapsLockState, Off
	If speedhotkeyon = EIN
	{
		Loop %numkeys0%
		{
			StringSplit, numkeyshotkey, numkeys%A_Index%
			Hotkey, NUMPAD%numkeyshotkey1% & NUMPAD%numkeyshotkey2%, Off
		}
		Loop %hotkeyslist0%
		{
			StringLeft, hotkeya, hotkeyslist%A_Index%, 1
			StringRight, hotkeyb, hotkeyslist%A_Index%, 1
			Hotkey, %hotkeya% & %hotkeyb%, Off
		}
		speedhotkeyon = AUS
		Hotkey, CAPSLOCK & TAB, ON
		Hotkey, ~LCONTROL, ON
		Hotkey, CAPSLOCK & SHIFT, ON
		ToolTip,,,,19
	}
	SetTimer, RemoveToolTip, Off
	If out =
		outrunvar = %outlast%
	else
	{
		outrunvar = %out%
		outlast = %out%
	}
	out =
	If outrunvar =
		Return
	If outrunvar is alnum
	{
		If %outrunvar%0 > 0
		{
			runningprograms++
			If runningprograms > 1
				tooltippos += 14
			else
				tooltippos = 0
			StringLeft, tooltipvar, %outrunvar%1, 50 
			ToolTip % tooltipvar, 300, %tooltippos%, %runningprograms%
		}
	}
	IniRead, checkvariable, %config%, %DEFAULT%, %outrunvar%, ERROR
	If checkvariable = ERROR
	{
		GoSub, Go
		Return
	}
	checkpath := %outrunvar%2
	/*
	StringGetPos, splitposend, checkpath, %A_Tab%, L2
	StringGetPos, splitposstart, checkpath, %A_Tab%
	MsgBox, out: %checkpath% start: %splitposstart% end: %splitposend%
	If Errorlevel = 0
	{
			splitposstart +=2
			If splitposend = -1
			{
				StringMid, checkpath, checkpath, %splitposstart%
			}
			else
			{
				splitposend -=%splitposstart%
				splitposend++
				StringMid, checkpath, checkpath, %splitposstart%, %splitposend%
			}
	}
	*/
	IfExist, %checkpath%
	{
			pathvar := %outrunvar%3
			If pathvar =
			{
				Run %checkpath%
			}
			else											
			{
				Run %checkpath%%A_Space%%pathvar%
			}
	}
	else
	{														
			input := %outrunvar%2
			If input is digit
			{
				decryptmakrokeys = %input%
				Decryptmakro(decryptmakrokeys, config)
				input = %decryptmakrokeys%
			}
			input := RegExReplace(input, macroseparator . "\s+", macroseparator)
			;input := RegExReplace(input, "\s+" . macroseparator, macroseparator)
			RunMacro()
	}
	If outrunvar is alnum
	{
		If %outrunvar%0 > 0
		{
			ToolTip,,,, %runningprograms%
			runningprograms--
			If runningprograms > 0
				tooltippos -= 14
		}
	}
	SetTimer, RemoveToolTip, 1000
	Return
}

;Runs one of your scripts(macro) 
RunMacro(looptimes=1, is_if=0, is_loop=0, is_block=0, last_is = 0, loop_opt1="", loop_opt2="", loop_opt3="")
{
	global ;global because to accept input and work with commands(forward %programparam1-20%)
	local inputparameters := input
	local inputparameterssave := input
	local programparam =
	local breakloop =
	breaksendkeys =
	If looptimes =
	{
		Loop
		{
			inputparameters = %inputparameterssave%
			;MsgBox, LOOP: %A_Index%
			Loop
			{
				;Break when input is empty
				If inputparameters =
				{
					break
				}
				
				;Break when end of loop or if
				If (SubStr(inputparameters, 1, 2) = "}" . macroseparator)
				{
					StringTrimLeft, inputparameters, inputparameters, 2
					break
				}
				
				;Exit when Macro is to cancel(pressed Pause Key)
				If breaksendkeys = 1
				{
					breaksendkeys =
					ToolTip, MACRO WAS CANCELED,,,20
					SetTimer, RemoveToolTip, 1000
					Loop
					{
						If runningprograms = 0
						{
							tooltippos = 0
							break
						}
						ToolTip,,,, %runningprograms%
						runningprograms--
						If runningprograms > 0
							tooltippos -= 14
					}
					Suspend, Off
					BlockInput, Off
					Exit
				}
				
				;Empty all parameters
				Loop 20
				{
					programparam%A_Index% =
				}
				
				;Check if last item or cut off command
				If InStr(inputparameters, macroseparator) = 0
				{
					programvar = %inputparameters%
					inputparameters =
				}
				else
				{
					StringLeft, programvar, inputparameters, InStr(inputparameters, macroseparator)-1
					StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
				}
				;programvar = %programvar%
				
				;Continue if comments
				If InStr(programvar, ";") = 1
					continue
				else if InStr(programvar, "/*") = 1
				{
					If InStr(inputparameters, "*/") = 0
						inputparameters =
					else
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, "*/")+2
					continue
				}
				
				;Cut off comments from Line
				If RegExMatch(programvar, "\s;") > 0
				{	
					StringLeft, programvar, programvar, RegExMatch(programvar, "\s;")-1
				}
				
				;Split Command into parameters, e.g MsgBox, hello: programparam1 will be MsgBox, programparam2 will be hello
				If (RegExMatch(programvar, "^\w*\(") = 1 and SubStr(programvar, 0, 1) = ")")
				{
					StringTrimRight, programvar, programvar, 1
					StringReplace, programvar, programvar, `(, `,
					StringSplit, programparam, programvar, `,, %A_Space%
				}
				else
					StringSplit, programparam, programvar, `,, %A_Space%
				
				;If program has variables(%...%) it will load the variables into parameters
				If (InStr(programvar, "`%") > 0 and programparam1 != "SendRaw")
				{ 
					AutoTrim, Off
					Loop 20
					{
						programvarwithvariable := InStr(programparam%A_Index%, "`%", CaseSensitive = true)
						If programvarwithvariable > 0
						{
							programparamtochangetemp := programparam%A_Index%
							programparamtochange = %programparamtochangetemp%
							;____________________________
							tempvar =
							Loop
							{
								If programparamtochange =
									break
								StringGetPos, programvarwithvariablepos, programparamtochange, `%
								If Errorlevel = 1
								{
									tempvartoadd := programparamtochange
									tempvar = %tempvar%%tempvartoadd%
									break
								}
								If  programvarwithvariablepos > 0
								{
									StringLeft, tempvartoadd, programparamtochange, %programvarwithvariablepos%
									;MsgBox, nonvar: %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
									StringTrimLeft, programparamtochange, programparamtochange, %programvarwithvariablepos%
								}
								else
								{
									StringTrimLeft, programparamtochange, programparamtochange, 1
									StringLeft, tempvartoadd, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									StringTrimRight, tempvartoadd, tempvartoadd, 1
									StringTrimLeft, programparamtochange, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									tempvartoadd := %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
								}
							}
							programparam%A_Index% = %tempvar%
						}
					}
					AutoTrim, On
				}
				
				;If no commas (,) than only 1 parameter, so send command(e.g. !{TAB}), loop(e.g. 10) or own macro/folder/program/website
				If programparam0 = 1
				{
					If programparam1 is alnum
					{
						out := programparam1
						If %out%2 =
						{
							out=
						}
						else
						{ 
							GoSub, Runvar
							Sleep, 100
							continue
						}
					}
				}
				
				;Replace tabs, linefeeds, and remove quotation marks(if at the end and beginnig only, requiered for DllCall) in parameters
				Loop 20
				{
					IfInString, programparam%A_Index%, ``t
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``t, %A_Tab%, A
					}
					IfInString, programparam%A_Index%, ``n
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``n, `n, A
					}
					If (quotationmark = SubStr(programparam%A_Index%, 1, 1) and quotationmark = SubStr(programparam%A_Index%, 0, 1))
					{
						StringTrimLeft, programparam%A_Index%, programparam%A_Index%, 1
						StringTrimRight, programparam%A_Index%, programparam%A_Index%, 1
					}
				}
				
				;Display command when variable/macro setdebugger is ON
				If (debuggerison = "ON" and programparam1 != "}")
				{
					tooltipdebugger=
					Loop %programparam0%
					{
						tooltipdebuggertmp := programparam%A_Index%
						tooltipdebugger = %tooltipdebugger%%tooltipdebuggertmp%`,
					}
					StringTrimRight, tooltipdebugger, tooltipdebugger, 1
					ToolTip % tooltipdebugger,,,20
					Sleep, %debuggerslowdown%
				}
				
				;Runs a Loop or an If statement
				If programparam1 = Loop
				{
					was_block = %is_block%
					;MsgBox, starting loop:`n%inputparameters%
					If (SubStr(inputparameters, 1, 2) = macroifloopblock)
					{
						StringTrimLeft, inputparameters, inputparameters, 2
						is_block = 1
					}
					else
						is_block = 0
					input := inputparameters
					is_loop++
					last_was = %last_is%
					last_is = 2
					inputparameters:=RunMacro(programparam2,is_if,is_loop,is_block,last_is, programparam3, programparam4, programparam5)
					is_loop--
					last_is = %last_was%
					if was_block = 1
					{
						was_block = 0
						is_block = 1
					}
					
					;MsgBox, ENDE`nloop: %is_loop%`nif: %is_if%`nblock: %is_block%`nlast: %last_is%
					;MsgBox, returned with:`n%inputparameters%
					
					continue
				}
				else if ((programparam1 = "If" and programparam5 = "") or ((programparam1 = "IMB" or programparam1 = "IfMsgBox" or programparam1 = "IE" or programparam1 = "IfExist" or programparam1 = "INE" or programparam1 = "IfNotExist") and programparam3 = "") or ((programparam1 = "IEQ" or programparam1 = "INEQ" or programparam1 = "IG" or programparam1 = "IGOE" or programparam1 = "IL" or programparam1 = "ILOE" or programparam1 = "IIS" or programparam1 = "INIS" or programparam1 = "IfEqual" or programparam1 = "IfNotEqual" or programparam1 = "IfGreater" or programparam1 = "IfGreaterOrEqual" or programparam1 = "IfLess" or programparam1 = "IfLessOrEqual" or programparam1 = "IfInString" or programparam1 = "IfNotInString") and programparam4 = "") or ((programparam1 = "IWA" or programparam1 = "IWNA" or programparam1 = "IWE" or programparam1 = "IWNE" or programparam1 = "IfWinActive" or programparam1 = "IfWinNotActive" or programparam1 = "IfWinExist" or programparam1 = "IfWinNotExist") and programparam6 = ""))
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					was_block = %is_block%
					is_if++
					last_was = %last_is%
					last_is = 1
					If Ifstatement() = 1
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
						If (SubStr(inputparameters, 1, 4) = "else")
						{
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							If (SubStr(inputparameters, 1, 2) = macroifloopblock)
							{
								If (InStr(inputparameters, macroifloopblockend) != 0)
									StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
								else
									inputparameters =
							}
							else if (InStr(inputparameters, macroseparator) !=0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							else
								inputparameters =	
						}	
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						
					}
					else
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							If (InStr(inputparameters, macroifloopblockend) != 0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
							else
								inputparameters =
						}
						else if (InStr(inputparameters, macroseparator) !=0)
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						else
							inputparameters =	
					}
					If (SubStr(inputparameters, 1, 4) = "else")
					{
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
					}
					;MsgBox, if:%inputparameters%
					continue
				}
				
				;If programparam1 = else, needs to delete as if used than it would run before
				If programparam1 = else
				{
					If (InStr(inputparameters, macroifloopblockend) != 0 and InStr(inputparameters, "{") = 1)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
					else if (InStr(inputparameters, macroseparator) !=0)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
					else
						inputparameters =
				}
					
				;Run command if exists/allowed
				IfInString, workingcommands, %programparam1%|
				{
					If (programparam1 != "" and programparam1 != "break" and programparam1 != "continue")
					{
						GoSub, %programparam1%
					}
				}
				else if (RegExMatch(programparam1, "^\w*\s?\s?=") = 0 and RegExMatch(programparam1, "^\w*\s?\s?:=") = 0 and programparam1 != "}")
				{
					Send, %programvar%
					continue
				}
				
				;!!!!!!!!!!!Return when Return is used
				If programparam1 = Return
				{
					inputparameters =
					Return "return" ;Unclear!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				}
				
				;Will break or continue if in a loop
				If (programparam1 = "break" or programparam1 = "continue")
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					If is_block > 0
					{
						If InStr(inputparameters, "}" . macroseparator) = 1
							StringTrimLeft, inputparameters, inputparameters, 2
						else
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+2
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					}
					If is_loop > 0
					{
						If last_is = 1
							inputparameters := programparam1 . macroseparator . inputparameters
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						Return inputparameters
					}
				}
				
				;Used for var=Value or var:=value or var:=DllCall,.... and so on
				IfInString, programparam1, =
				{
					If (programparam0 = 1 or InStr(programparam1, "FileExist") or InStr(programparam1, "GetKeyState") or InStr(programparam1, "InStr") or InStr(programparam1, "RegExMatch") or InStr(programparam1, "RegExReplace") or InStr(programparam1, "SubStr") or InStr(programparam1, "StrLen") or InStr(programparam1, "WinActive") or InStr(programparam1, "WinExist") or InStr(programparam1, "Asc") or InStr(programparam1, "Chr") or InStr(programparam1, "DllCall") or InStr(programparam1, VarSetCapacity))
					{
						IfInString, programparam1, :=
						{
							StringReplace, programparam1, programparam1, :=, =
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							;MSgBox, %programparamvar1%`n%programparamvar2%
							If programparam2 =
							{
								%programparamvar1% := %programparamvar2%
							}
							else
							{
								If programparamvar2 = FileExist
								{
									%programparamvar1% := FileExist(programparam2)
								}
								else if programparamvar2 = GetKeyState
								{
									%programparamvar1% := GetKeyState(programparam2,programparam3)
								}
								else if programparamvar2 = InStr
								{
									MsgBox, 1: %programparam1%`n2: %programparam2%`n2: %programparam3%`n2: %programparam4%
									%programparamvar1% := InStr(%programparam2%, programparam3,programparam4, programparam5)
								}
								else if programparamvar2 = RegExMatch
								{
									%programparamvar1% := RegExMatch(%programparam2%, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = RegExReplace
								{
									%programparamvar1% := RegExReplace(%programparam2%, programparam3, programparam4, programparam5, programparam6, programparam7)
								}
								else if programparamvar2 = SubStr
								{
									%programparamvar1% := SubStr(programparam2, programparam3, programparam4)
								}
								else if programparamvar2 = StrLen
								{
									%programparamvar1% := StrLen(programparam2)
								}
								else if programparamvar2 = WinActive
								{
									%programparamvar1% := WinActive(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = WinExist
								{
									%programparamvar1% := WinExist(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = Asc
								{
									%programparamvar1% := Asc(programparam2)
								}
								else if programparamvar2 = Chr
								{
									%programparamvar1% := Chr(programparam2)
								}
								else if programparamvar2 = DllCall
								{
									If programparam0 = 20
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19, programparam20)
								  }
								  else if programparam0 = 19
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19)
								  }
								  else if programparam0 = 18
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18)
								  }
								  else if programparam0 = 17
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17)
								  }
								  else if programparam0 = 16
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16)
								  }
								  else if programparam0 = 15
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15)
								  }
								  else if programparam0 = 14
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14)
								  }
								  else if programparam0 = 13
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13)
								  }
								  else if programparam0 = 12
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12)
								  }
								  else if programparam0 = 11
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11)
								  }
								  else if programparam0 = 10
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10)
								  }
								  else if programparam0 = 9
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9)
								  }
								  else if programparam0 = 8
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8)
								  }
								  else if programparam0 = 7
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7)
								  }
								  else if programparam0 = 6
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6)
								  }
								  else if programparam0 = 5
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5)
								  }
								  else if programparam0 = 4
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4)
								  }
								  else if programparam0 = 3
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3)
								  }
								  else if programparam0 = 2
									{
								  	%programparamvar1% := DllCall( programparam2)
								  }
								}
								else if programparamvar2 = VarSetCapacity
								{
									%programparamvar1% := VarSetCapacity(%programparam2%, programparam3, programparam4)
								}
							}
						}
						else
						{
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							%programparamvar1% = %programparamvar2%
						}
					}
				}
				
				If (last_is > 0 and is_block = 0)
					break
			}
		}
	}
	else if looptimes is digit
	{
		Loop %looptimes%
		{
			inputparameters = %inputparameterssave%
			;MsgBox, LOOP: %A_Index%
			Loop
			{
				;Break when input is empty
				If inputparameters =
				{
					break
				}
				
				;Break when end of loop or if
				If (SubStr(inputparameters, 1, 2) = "}" . macroseparator)
				{
					StringTrimLeft, inputparameters, inputparameters, 2
					break
				}
				
				;Exit when Macro is to cancel(pressed Pause Key)
				If breaksendkeys = 1
				{
					breaksendkeys =
					ToolTip, MACRO WAS CANCELED,,,20
					SetTimer, RemoveToolTip, 1000
					Loop
					{
						If runningprograms = 0
						{
							tooltippos = 0
							break
						}
						ToolTip,,,, %runningprograms%
						runningprograms--
						If runningprograms > 0
							tooltippos -= 14
					}
					Suspend, Off
					BlockInput, Off
					Exit
				}
				
				;Empty all parameters
				Loop 20
				{
					programparam%A_Index% =
				}
				
				;Check if last item or cut off command
				If InStr(inputparameters, macroseparator) = 0
				{
					programvar = %inputparameters%
					inputparameters =
				}
				else
				{
					StringLeft, programvar, inputparameters, InStr(inputparameters, macroseparator)-1
					StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
				}
				;programvar = %programvar%
				
				;Continue if comments
				If InStr(programvar, ";") = 1
					continue
				else if InStr(programvar, "/*") = 1
				{
					If InStr(inputparameters, "*/") = 0
						inputparameters =
					else
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, "*/")+2
					continue
				}
				
				;Cut off comments from Line
				If RegExMatch(programvar, "\s;") > 0
				{	
					StringLeft, programvar, programvar, RegExMatch(programvar, "\s;")-1
				}
				
				;Split Command into parameters, e.g MsgBox, hello: programparam1 will be MsgBox, programparam2 will be hello
				If (RegExMatch(programvar, "^\w*\(") = 1 and SubStr(programvar, 0, 1) = ")")
				{
					StringTrimRight, programvar, programvar, 1
					StringReplace, programvar, programvar, `(, `,
					StringSplit, programparam, programvar, `,, %A_Space%
				}
				else
					StringSplit, programparam, programvar, `,, %A_Space%
				
				;If program has variables(%...%) it will load the variables into parameters
				If (InStr(programvar, "`%") > 0 and programparam1 != "SendRaw")
				{ 
					AutoTrim, Off
					Loop 20
					{
						programvarwithvariable := InStr(programparam%A_Index%, "`%", CaseSensitive = true)
						If programvarwithvariable > 0
						{
							programparamtochangetemp := programparam%A_Index%
							programparamtochange = %programparamtochangetemp%
							;____________________________
							tempvar =
							Loop
							{
								If programparamtochange =
									break
								StringGetPos, programvarwithvariablepos, programparamtochange, `%
								If Errorlevel = 1
								{
									tempvartoadd := programparamtochange
									tempvar = %tempvar%%tempvartoadd%
									break
								}
								If  programvarwithvariablepos > 0
								{
									StringLeft, tempvartoadd, programparamtochange, %programvarwithvariablepos%
									;MsgBox, nonvar: %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
									StringTrimLeft, programparamtochange, programparamtochange, %programvarwithvariablepos%
								}
								else
								{
									StringTrimLeft, programparamtochange, programparamtochange, 1
									StringLeft, tempvartoadd, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									StringTrimRight, tempvartoadd, tempvartoadd, 1
									StringTrimLeft, programparamtochange, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									tempvartoadd := %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
								}
							}
							programparam%A_Index% = %tempvar%
						}
					}
					AutoTrim, On
				}
				
				;If no commas (,) than only 1 parameter, so send command(e.g. !{TAB}), loop(e.g. 10) or own macro/folder/program/website
				If programparam0 = 1
				{
					If programparam1 is alnum
					{
						out := programparam1
						If %out%2 =
						{
							out=
						}
						else
						{ 
							GoSub, Runvar
							Sleep, 100
							continue
						}
					}
				}
				
				;Replace tabs, linefeeds, and remove quotation marks(if at the end and beginnig only, requiered for DllCall) in parameters
				Loop 20
				{
					IfInString, programparam%A_Index%, ``t
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``t, %A_Tab%, A
					}
					IfInString, programparam%A_Index%, ``n
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``n, `n, A
					}
					If (quotationmark = SubStr(programparam%A_Index%, 1, 1) and quotationmark = SubStr(programparam%A_Index%, 0, 1))
					{
						StringTrimLeft, programparam%A_Index%, programparam%A_Index%, 1
						StringTrimRight, programparam%A_Index%, programparam%A_Index%, 1
					}
				}
				
				;Display command when variable/macro setdebugger is ON
				If (debuggerison = "ON" and programparam1 != "}")
				{
					tooltipdebugger=
					Loop %programparam0%
					{
						tooltipdebuggertmp := programparam%A_Index%
						tooltipdebugger = %tooltipdebugger%%tooltipdebuggertmp%`,
					}
					StringTrimRight, tooltipdebugger, tooltipdebugger, 1
					ToolTip % tooltipdebugger,,,20
					Sleep, %debuggerslowdown%
				}
				
				;Runs a Loop or an If statement
				If programparam1 = Loop
				{
					was_block = %is_block%
					;MsgBox, starting loop:`n%inputparameters%
					If (SubStr(inputparameters, 1, 2) = macroifloopblock)
					{
						StringTrimLeft, inputparameters, inputparameters, 2
						is_block = 1
					}
					else
						is_block = 0
					input := inputparameters
					is_loop++
					last_was = %last_is%
					last_is = 2
					inputparameters:=RunMacro(programparam2,is_if,is_loop,is_block,last_is, programparam3, programparam4, programparam5)
					is_loop--
					last_is = %last_was%
					if was_block = 1
					{
						was_block = 0
						is_block = 1
					}
					
					;MsgBox, ENDE`nloop: %is_loop%`nif: %is_if%`nblock: %is_block%`nlast: %last_is%
					;MsgBox, returned with:`n%inputparameters%
					
					continue
				}
				else if ((programparam1 = "If" and programparam5 = "") or ((programparam1 = "IMB" or programparam1 = "IfMsgBox" or programparam1 = "IE" or programparam1 = "IfExist" or programparam1 = "INE" or programparam1 = "IfNotExist") and programparam3 = "") or ((programparam1 = "IEQ" or programparam1 = "INEQ" or programparam1 = "IG" or programparam1 = "IGOE" or programparam1 = "IL" or programparam1 = "ILOE" or programparam1 = "IIS" or programparam1 = "INIS" or programparam1 = "IfEqual" or programparam1 = "IfNotEqual" or programparam1 = "IfGreater" or programparam1 = "IfGreaterOrEqual" or programparam1 = "IfLess" or programparam1 = "IfLessOrEqual" or programparam1 = "IfInString" or programparam1 = "IfNotInString") and programparam4 = "") or ((programparam1 = "IWA" or programparam1 = "IWNA" or programparam1 = "IWE" or programparam1 = "IWNE" or programparam1 = "IfWinActive" or programparam1 = "IfWinNotActive" or programparam1 = "IfWinExist" or programparam1 = "IfWinNotExist") and programparam6 = ""))
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					was_block = %is_block%
					is_if++
					last_was = %last_is%
					last_is = 1
					If Ifstatement() = 1
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
						If (SubStr(inputparameters, 1, 4) = "else")
						{
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							If (SubStr(inputparameters, 1, 2) = macroifloopblock)
							{
								If (InStr(inputparameters, macroifloopblockend) != 0)
									StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
								else
									inputparameters =
							}
							else if (InStr(inputparameters, macroseparator) !=0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							else
								inputparameters =	
						}	
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						
					}
					else
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							If (InStr(inputparameters, macroifloopblockend) != 0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
							else
								inputparameters =
						}
						else if (InStr(inputparameters, macroseparator) !=0)
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						else
							inputparameters =	
					}
					If (SubStr(inputparameters, 1, 4) = "else")
					{
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
					}
					;MsgBox, if:%inputparameters%
					continue
				}
				
				;If programparam1 = else, needs to delete as if used than it would run before
				If programparam1 = else
				{
					If (InStr(inputparameters, macroifloopblockend) != 0 and InStr(inputparameters, "{") = 1)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
					else if (InStr(inputparameters, macroseparator) !=0)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
					else
						inputparameters =
				}
					
				;Run command if exists/allowed
				IfInString, workingcommands, %programparam1%|
				{
					If (programparam1 != "" and programparam1 != "break" and programparam1 != "continue")
					{
						GoSub, %programparam1%
					}
				}
				else if (RegExMatch(programparam1, "^\w*\s?\s?=") = 0 and RegExMatch(programparam1, "^\w*\s?\s?:=") = 0 and programparam1 != "}")
				{
					Send, %programvar%
					continue
				}
				
				;!!!!!!!!!!!Return when Return is used
				If programparam1 = Return
				{
					inputparameters =
					Return "return" ;Unclear!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				}
				
				;Will break or continue if in a loop
				If (programparam1 = "break" or programparam1 = "continue")
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					If is_block > 0
					{
						If InStr(inputparameters, "}" . macroseparator) = 1
							StringTrimLeft, inputparameters, inputparameters, 2
						else
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+2
					}
					If is_loop > 0
					{
						If last_is = 1
							inputparameters := programparam1 . macroseparator . inputparameters
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						Return inputparameters
					}
				}
				
				;Used for var=Value or var:=value or var:=DllCall,.... and so on
				IfInString, programparam1, =
				{
					If (programparam0 = 1 or InStr(programparam1, "FileExist") or InStr(programparam1, "GetKeyState") or InStr(programparam1, "InStr") or InStr(programparam1, "RegExMatch") or InStr(programparam1, "RegExReplace") or InStr(programparam1, "SubStr") or InStr(programparam1, "StrLen") or InStr(programparam1, "WinActive") or InStr(programparam1, "WinExist") or InStr(programparam1, "Asc") or InStr(programparam1, "Chr") or InStr(programparam1, "DllCall") or InStr(programparam1, VarSetCapacity))
					{
						IfInString, programparam1, :=
						{
							StringReplace, programparam1, programparam1, :=, =
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							If programparam2 =
							{
								%programparamvar1% := %programparamvar2%
							}
							else
							{
								If programparamvar2 = FileExist
								{
									%programparamvar1% := FileExist(programparam2)
								}
								else if programparamvar2 = GetKeyState
								{
									%programparamvar1% := GetKeyState(programparam2,programparam3)
								}
								else if programparamvar2 = InStr
								{
									MsgBox, 1: %programparam1%`n2: %programparam2%`n2: %programparam3%`n2: %programparam4%
									%programparamvar1% := InStr(%programparam2%, programparam3,programparam4, programparam5)
								}
								else if programparamvar2 = RegExMatch
								{
									%programparamvar1% := RegExMatch(%programparam2%, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = RegExReplace
								{
									%programparamvar1% := RegExReplace(%programparam2%, programparam3, programparam4, programparam5, programparam6, programparam7)
								}
								else if programparamvar2 = SubStr
								{
									%programparamvar1% := SubStr(programparam2, programparam3, programparam4)
								}
								else if programparamvar2 = StrLen
								{
									%programparamvar1% := StrLen(programparam2)
								}
								else if programparamvar2 = WinActive
								{
									%programparamvar1% := WinActive(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = WinExist
								{
									%programparamvar1% := WinExist(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = Asc
								{
									%programparamvar1% := Asc(programparam2)
								}
								else if programparamvar2 = Chr
								{
									%programparamvar1% := Chr(programparam2)
								}
								else if programparamvar2 = DllCall
								{
									If programparam0 = 20
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19, programparam20)
								  }
								  else if programparam0 = 19
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19)
								  }
								  else if programparam0 = 18
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18)
								  }
								  else if programparam0 = 17
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17)
								  }
								  else if programparam0 = 16
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16)
								  }
								  else if programparam0 = 15
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15)
								  }
								  else if programparam0 = 14
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14)
								  }
								  else if programparam0 = 13
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13)
								  }
								  else if programparam0 = 12
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12)
								  }
								  else if programparam0 = 11
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11)
								  }
								  else if programparam0 = 10
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10)
								  }
								  else if programparam0 = 9
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9)
								  }
								  else if programparam0 = 8
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8)
								  }
								  else if programparam0 = 7
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7)
								  }
								  else if programparam0 = 6
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6)
								  }
								  else if programparam0 = 5
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5)
								  }
								  else if programparam0 = 4
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4)
								  }
								  else if programparam0 = 3
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3)
								  }
								  else if programparam0 = 2
									{
								  	%programparamvar1% := DllCall( programparam2)
								  }
								}
								else if programparamvar2 = VarSetCapacity
								{
									%programparamvar1% := VarSetCapacity(%programparam2%, programparam3, programparam4)
								}
							}
						}
						else
						{
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							%programparamvar1% = %programparamvar2%
						}
					}
				}
				
				If (last_is > 0 and is_block = 0)
					break
			}
		}
	}
	else if looptimes = Parse
	{
		Loop, Parse, %loop_opt1%, %loop_opt2%, %loop_opt3%
		{
			inputparameters = %inputparameterssave%
			;MsgBox, LOOP: %A_Index%
			Loop
			{
				;Break when input is empty
				If inputparameters =
				{
					break
				}
				
				;Break when end of loop or if
				If (SubStr(inputparameters, 1, 2) = "}" . macroseparator)
				{
					StringTrimLeft, inputparameters, inputparameters, 2
					break
				}
				
				;Exit when Macro is to cancel(pressed Pause Key)
				If breaksendkeys = 1
				{
					breaksendkeys =
					ToolTip, MACRO WAS CANCELED,,,20
					SetTimer, RemoveToolTip, 1000
					Loop
					{
						If runningprograms = 0
						{
							tooltippos = 0
							break
						}
						ToolTip,,,, %runningprograms%
						runningprograms--
						If runningprograms > 0
							tooltippos -= 14
					}
					Suspend, Off
					BlockInput, Off
					Exit
				}
				
				;Empty all parameters
				Loop 20
				{
					programparam%A_Index% =
				}
				
				;Check if last item or cut off command
				If InStr(inputparameters, macroseparator) = 0
				{
					programvar = %inputparameters%
					inputparameters =
				}
				else
				{
					StringLeft, programvar, inputparameters, InStr(inputparameters, macroseparator)-1
					StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
				}
				;programvar = %programvar%
				
				;Continue if comments
				If InStr(programvar, ";") = 1
					continue
				else if InStr(programvar, "/*") = 1
				{
					If InStr(inputparameters, "*/") = 0
						inputparameters =
					else
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, "*/")+2
					continue
				}
				
				;Cut off comments from Line
				If RegExMatch(programvar, "\s;") > 0
				{	
					StringLeft, programvar, programvar, RegExMatch(programvar, "\s;")-1
				}
				
				;Split Command into parameters, e.g MsgBox, hello: programparam1 will be MsgBox, programparam2 will be hello
				If (RegExMatch(programvar, "^\w*\(") = 1 and SubStr(programvar, 0, 1) = ")")
				{
					StringTrimRight, programvar, programvar, 1
					StringReplace, programvar, programvar, `(, `,
					StringSplit, programparam, programvar, `,, %A_Space%
				}
				else
					StringSplit, programparam, programvar, `,, %A_Space%
				
				;If program has variables(%...%) it will load the variables into parameters
				If (InStr(programvar, "`%") > 0 and programparam1 != "SendRaw")
				{ 
					AutoTrim, Off
					Loop 20
					{
						programvarwithvariable := InStr(programparam%A_Index%, "`%", CaseSensitive = true)
						If programvarwithvariable > 0
						{
							programparamtochangetemp := programparam%A_Index%
							programparamtochange = %programparamtochangetemp%
							;____________________________
							tempvar =
							Loop
							{
								If programparamtochange =
									break
								StringGetPos, programvarwithvariablepos, programparamtochange, `%
								If Errorlevel = 1
								{
									tempvartoadd := programparamtochange
									tempvar = %tempvar%%tempvartoadd%
									break
								}
								If  programvarwithvariablepos > 0
								{
									StringLeft, tempvartoadd, programparamtochange, %programvarwithvariablepos%
									;MsgBox, nonvar: %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
									StringTrimLeft, programparamtochange, programparamtochange, %programvarwithvariablepos%
								}
								else
								{
									StringTrimLeft, programparamtochange, programparamtochange, 1
									StringLeft, tempvartoadd, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									StringTrimRight, tempvartoadd, tempvartoadd, 1
									StringTrimLeft, programparamtochange, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									tempvartoadd := %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
								}
							}
							programparam%A_Index% = %tempvar%
						}
					}
					AutoTrim, On
				}
				
				;If no commas (,) than only 1 parameter, so send command(e.g. !{TAB}), loop(e.g. 10) or own macro/folder/program/website
				If programparam0 = 1
				{
					If programparam1 is alnum
					{
						out := programparam1
						If %out%2 =
						{
							out=
						}
						else
						{ 
							GoSub, Runvar
							Sleep, 100
							continue
						}
					}
				}
				
				;Replace tabs, linefeeds, and remove quotation marks(if at the end and beginnig only, requiered for DllCall) in parameters
				Loop 20
				{
					IfInString, programparam%A_Index%, ``t
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``t, %A_Tab%, A
					}
					IfInString, programparam%A_Index%, ``n
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``n, `n, A
					}
					If (quotationmark = SubStr(programparam%A_Index%, 1, 1) and quotationmark = SubStr(programparam%A_Index%, 0, 1))
					{
						StringTrimLeft, programparam%A_Index%, programparam%A_Index%, 1
						StringTrimRight, programparam%A_Index%, programparam%A_Index%, 1
					}
				}
				
				;Display command when variable/macro setdebugger is ON
				If (debuggerison = "ON" and programparam1 != "}")
				{
					tooltipdebugger=
					Loop %programparam0%
					{
						tooltipdebuggertmp := programparam%A_Index%
						tooltipdebugger = %tooltipdebugger%%tooltipdebuggertmp%`,
					}
					StringTrimRight, tooltipdebugger, tooltipdebugger, 1
					ToolTip % tooltipdebugger,,,20
					Sleep, %debuggerslowdown%
				}
				
				;Runs a Loop or an If statement
				If programparam1 = Loop
				{
					was_block = %is_block%
					;MsgBox, starting loop:`n%inputparameters%
					If (SubStr(inputparameters, 1, 2) = macroifloopblock)
					{
						StringTrimLeft, inputparameters, inputparameters, 2
						is_block = 1
					}
					else
						is_block = 0
					input := inputparameters
					is_loop++
					last_was = %last_is%
					last_is = 2
					inputparameters:=RunMacro(programparam2,is_if,is_loop,is_block,last_is, programparam3, programparam4, programparam5)
					is_loop--
					last_is = %last_was%
					if was_block = 1
					{
						was_block = 0
						is_block = 1
					}
					
					;MsgBox, ENDE`nloop: %is_loop%`nif: %is_if%`nblock: %is_block%`nlast: %last_is%
					;MsgBox, returned with:`n%inputparameters%
					
					continue
				}
				else if ((programparam1 = "If" and programparam5 = "") or ((programparam1 = "IMB" or programparam1 = "IfMsgBox" or programparam1 = "IE" or programparam1 = "IfExist" or programparam1 = "INE" or programparam1 = "IfNotExist") and programparam3 = "") or ((programparam1 = "IEQ" or programparam1 = "INEQ" or programparam1 = "IG" or programparam1 = "IGOE" or programparam1 = "IL" or programparam1 = "ILOE" or programparam1 = "IIS" or programparam1 = "INIS" or programparam1 = "IfEqual" or programparam1 = "IfNotEqual" or programparam1 = "IfGreater" or programparam1 = "IfGreaterOrEqual" or programparam1 = "IfLess" or programparam1 = "IfLessOrEqual" or programparam1 = "IfInString" or programparam1 = "IfNotInString") and programparam4 = "") or ((programparam1 = "IWA" or programparam1 = "IWNA" or programparam1 = "IWE" or programparam1 = "IWNE" or programparam1 = "IfWinActive" or programparam1 = "IfWinNotActive" or programparam1 = "IfWinExist" or programparam1 = "IfWinNotExist") and programparam6 = ""))
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					was_block = %is_block%
					is_if++
					last_was = %last_is%
					last_is = 1
					If Ifstatement() = 1
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
						If (SubStr(inputparameters, 1, 4) = "else")
						{
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							If (SubStr(inputparameters, 1, 2) = macroifloopblock)
							{
								If (InStr(inputparameters, macroifloopblockend) != 0)
									StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
								else
									inputparameters =
							}
							else if (InStr(inputparameters, macroseparator) !=0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							else
								inputparameters =	
						}	
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						
					}
					else
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							If (InStr(inputparameters, macroifloopblockend) != 0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
							else
								inputparameters =
						}
						else if (InStr(inputparameters, macroseparator) !=0)
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						else
							inputparameters =	
					}
					If (SubStr(inputparameters, 1, 4) = "else")
					{
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
					}
					;MsgBox, if:%inputparameters%
					continue
				}
				
				;If programparam1 = else, needs to delete as if used than it would run before
				If programparam1 = else
				{
					If (InStr(inputparameters, macroifloopblockend) != 0 and InStr(inputparameters, "{") = 1)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
					else if (InStr(inputparameters, macroseparator) !=0)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
					else
						inputparameters =
				}
					
				;Run command if exists/allowed
				IfInString, workingcommands, %programparam1%|
				{
					If (programparam1 != "" and programparam1 != "break" and programparam1 != "continue")
					{
						GoSub, %programparam1%
					}
				}
				else if (RegExMatch(programparam1, "^\w*\s?\s?=") = 0 and RegExMatch(programparam1, "^\w*\s?\s?:=") = 0 and programparam1 != "}")
				{
					Send, %programvar%
					continue
				}
				
				;!!!!!!!!!!!Return when Return is used
				If programparam1 = Return
				{
					inputparameters =
					Return "return" ;Unclear!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				}
				
				;Will break or continue if in a loop
				If (programparam1 = "break" or programparam1 = "continue")
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					If is_block > 0
					{
						If InStr(inputparameters, "}" . macroseparator) = 1
							StringTrimLeft, inputparameters, inputparameters, 2
						else
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+2
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					}
					If is_loop > 0
					{
						If last_is = 1
							inputparameters := programparam1 . macroseparator . inputparameters
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						Return inputparameters
					}
				}
				
				;Used for var=Value or var:=value or var:=DllCall,.... and so on
				IfInString, programparam1, =
				{
					If (programparam0 = 1 or InStr(programparam1, "FileExist") or InStr(programparam1, "GetKeyState") or InStr(programparam1, "InStr") or InStr(programparam1, "RegExMatch") or InStr(programparam1, "RegExReplace") or InStr(programparam1, "SubStr") or InStr(programparam1, "StrLen") or InStr(programparam1, "WinActive") or InStr(programparam1, "WinExist") or InStr(programparam1, "Asc") or InStr(programparam1, "Chr") or InStr(programparam1, "DllCall") or InStr(programparam1, VarSetCapacity))
					{
						IfInString, programparam1, :=
						{
							StringReplace, programparam1, programparam1, :=, =
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							;MSgBox, %programparamvar1%`n%programparamvar2%
							If programparam2 =
							{
								%programparamvar1% := %programparamvar2%
							}
							else
							{
								If programparamvar2 = FileExist
								{
									%programparamvar1% := FileExist(programparam2)
								}
								else if programparamvar2 = GetKeyState
								{
									%programparamvar1% := GetKeyState(programparam2,programparam3)
								}
								else if programparamvar2 = InStr
								{
									MsgBox, 1: %programparam1%`n2: %programparam2%`n2: %programparam3%`n2: %programparam4%
									%programparamvar1% := InStr(%programparam2%, programparam3,programparam4, programparam5)
								}
								else if programparamvar2 = RegExMatch
								{
									%programparamvar1% := RegExMatch(%programparam2%, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = RegExReplace
								{
									%programparamvar1% := RegExReplace(%programparam2%, programparam3, programparam4, programparam5, programparam6, programparam7)
								}
								else if programparamvar2 = SubStr
								{
									%programparamvar1% := SubStr(programparam2, programparam3, programparam4)
								}
								else if programparamvar2 = StrLen
								{
									%programparamvar1% := StrLen(programparam2)
								}
								else if programparamvar2 = WinActive
								{
									%programparamvar1% := WinActive(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = WinExist
								{
									%programparamvar1% := WinExist(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = Asc
								{
									%programparamvar1% := Asc(programparam2)
								}
								else if programparamvar2 = Chr
								{
									%programparamvar1% := Chr(programparam2)
								}
								else if programparamvar2 = DllCall
								{
									If programparam0 = 20
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19, programparam20)
								  }
								  else if programparam0 = 19
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19)
								  }
								  else if programparam0 = 18
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18)
								  }
								  else if programparam0 = 17
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17)
								  }
								  else if programparam0 = 16
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16)
								  }
								  else if programparam0 = 15
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15)
								  }
								  else if programparam0 = 14
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14)
								  }
								  else if programparam0 = 13
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13)
								  }
								  else if programparam0 = 12
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12)
								  }
								  else if programparam0 = 11
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11)
								  }
								  else if programparam0 = 10
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10)
								  }
								  else if programparam0 = 9
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9)
								  }
								  else if programparam0 = 8
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8)
								  }
								  else if programparam0 = 7
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7)
								  }
								  else if programparam0 = 6
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6)
								  }
								  else if programparam0 = 5
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5)
								  }
								  else if programparam0 = 4
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4)
								  }
								  else if programparam0 = 3
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3)
								  }
								  else if programparam0 = 2
									{
								  	%programparamvar1% := DllCall( programparam2)
								  }
								}
								else if programparamvar2 = VarSetCapacity
								{
									%programparamvar1% := VarSetCapacity(%programparam2%, programparam3, programparam4)
								}
							}
						}
						else
						{
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							%programparamvar1% = %programparamvar2%
						}
					}
				}
				
				If (last_is > 0 and is_block = 0)
					break
			}
		}
	}
	else
	{
		Loop, %looptimes%, %loop_opt1%, %loop_opt2%, %loop_opt3%
		{
			inputparameters = %inputparameterssave%
			;MsgBox, LOOP: %A_Index%
			Loop
			{
				;Break when input is empty
				If inputparameters =
				{
					break
				}
				
				;Break when end of loop or if
				If (SubStr(inputparameters, 1, 2) = "}" . macroseparator)
				{
					StringTrimLeft, inputparameters, inputparameters, 2
					break
				}
				
				;Exit when Macro is to cancel(pressed Pause Key)
				If breaksendkeys = 1
				{
					breaksendkeys =
					ToolTip, MACRO WAS CANCELED,,,20
					SetTimer, RemoveToolTip, 1000
					Loop
					{
						If runningprograms = 0
						{
							tooltippos = 0
							break
						}
						ToolTip,,,, %runningprograms%
						runningprograms--
						If runningprograms > 0
							tooltippos -= 14
					}
					Suspend, Off
					BlockInput, Off
					Exit
				}
				
				;Empty all parameters
				Loop 20
				{
					programparam%A_Index% =
				}
				
				;Check if last item or cut off command
				If InStr(inputparameters, macroseparator) = 0
				{
					programvar = %inputparameters%
					inputparameters =
				}
				else
				{
					StringLeft, programvar, inputparameters, InStr(inputparameters, macroseparator)-1
					StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
				}
				;programvar = %programvar%
				
				;Continue if comments
				If InStr(programvar, ";") = 1
					continue
				else if InStr(programvar, "/*") = 1
				{
					If InStr(inputparameters, "*/") = 0
						inputparameters =
					else
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, "*/")+2
					continue
				}
				
				;Cut off comments from Line
				If RegExMatch(programvar, "\s;") > 0
				{	
					StringLeft, programvar, programvar, RegExMatch(programvar, "\s;")-1
				}
				
				;Split Command into parameters, e.g MsgBox, hello: programparam1 will be MsgBox, programparam2 will be hello
				If (RegExMatch(programvar, "^\w*\(") = 1 and SubStr(programvar, 0, 1) = ")")
				{
					StringTrimRight, programvar, programvar, 1
					StringReplace, programvar, programvar, `(, `,
					StringSplit, programparam, programvar, `,, %A_Space%
				}
				else
					StringSplit, programparam, programvar, `,, %A_Space%
				
				;If program has variables(%...%) it will load the variables into parameters
				If (InStr(programvar, "`%") > 0 and programparam1 != "SendRaw")
				{ 
					AutoTrim, Off
					Loop 20
					{
						programvarwithvariable := InStr(programparam%A_Index%, "`%", CaseSensitive = true)
						If programvarwithvariable > 0
						{
							programparamtochangetemp := programparam%A_Index%
							programparamtochange = %programparamtochangetemp%
							;____________________________
							tempvar =
							Loop
							{
								If programparamtochange =
									break
								StringGetPos, programvarwithvariablepos, programparamtochange, `%
								If Errorlevel = 1
								{
									tempvartoadd := programparamtochange
									tempvar = %tempvar%%tempvartoadd%
									break
								}
								If  programvarwithvariablepos > 0
								{
									StringLeft, tempvartoadd, programparamtochange, %programvarwithvariablepos%
									;MsgBox, nonvar: %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
									StringTrimLeft, programparamtochange, programparamtochange, %programvarwithvariablepos%
								}
								else
								{
									StringTrimLeft, programparamtochange, programparamtochange, 1
									StringLeft, tempvartoadd, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									StringTrimRight, tempvartoadd, tempvartoadd, 1
									StringTrimLeft, programparamtochange, programparamtochange, InStr(programparamtochange, "`%", CaseSensitive = true)
									tempvartoadd := %tempvartoadd%
									tempvar = %tempvar%%tempvartoadd%
								}
							}
							programparam%A_Index% = %tempvar%
						}
					}
					AutoTrim, On
				}
				
				;If no commas (,) than only 1 parameter, so send command(e.g. !{TAB}), loop(e.g. 10) or own macro/folder/program/website
				If programparam0 = 1
				{
					If programparam1 is alnum
					{
						out := programparam1
						If %out%2 =
						{
							out=
						}
						else
						{ 
							GoSub, Runvar
							Sleep, 100
							continue
						}
					}
				}
				
				;Replace tabs, linefeeds, and remove quotation marks(if at the end and beginnig only, requiered for DllCall) in parameters
				Loop 20
				{
					IfInString, programparam%A_Index%, ``t
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``t, %A_Tab%, A
					}
					IfInString, programparam%A_Index%, ``n
					{
						StringReplace, programparam%A_Index%, programparam%A_Index%, ``n, `n, A
					}
					If (quotationmark = SubStr(programparam%A_Index%, 1, 1) and quotationmark = SubStr(programparam%A_Index%, 0, 1))
					{
						StringTrimLeft, programparam%A_Index%, programparam%A_Index%, 1
						StringTrimRight, programparam%A_Index%, programparam%A_Index%, 1
					}
				}
				
				;Display command when variable/macro setdebugger is ON
				If (debuggerison = "ON" and programparam1 != "}")
				{
					tooltipdebugger=
					Loop %programparam0%
					{
						tooltipdebuggertmp := programparam%A_Index%
						tooltipdebugger = %tooltipdebugger%%tooltipdebuggertmp%`,
					}
					StringTrimRight, tooltipdebugger, tooltipdebugger, 1
					ToolTip % tooltipdebugger,,,20
					Sleep, %debuggerslowdown%
				}
				
				;Runs a Loop or an If statement
				If programparam1 = Loop
				{
					was_block = %is_block%
					;MsgBox, starting loop:`n%inputparameters%
					If (SubStr(inputparameters, 1, 2) = macroifloopblock)
					{
						StringTrimLeft, inputparameters, inputparameters, 2
						is_block = 1
					}
					else
						is_block = 0
					input := inputparameters
					is_loop++
					last_was = %last_is%
					last_is = 2
					inputparameters:=RunMacro(programparam2,is_if,is_loop,is_block,last_is, programparam3, programparam4, programparam5)
					is_loop--
					last_is = %last_was%
					if was_block = 1
					{
						was_block = 0
						is_block = 1
					}
					
					;MsgBox, ENDE`nloop: %is_loop%`nif: %is_if%`nblock: %is_block%`nlast: %last_is%
					;MsgBox, returned with:`n%inputparameters%
					
					continue
				}
				else if ((programparam1 = "If" and programparam5 = "") or ((programparam1 = "IMB" or programparam1 = "IfMsgBox" or programparam1 = "IE" or programparam1 = "IfExist" or programparam1 = "INE" or programparam1 = "IfNotExist") and programparam3 = "") or ((programparam1 = "IEQ" or programparam1 = "INEQ" or programparam1 = "IG" or programparam1 = "IGOE" or programparam1 = "IL" or programparam1 = "ILOE" or programparam1 = "IIS" or programparam1 = "INIS" or programparam1 = "IfEqual" or programparam1 = "IfNotEqual" or programparam1 = "IfGreater" or programparam1 = "IfGreaterOrEqual" or programparam1 = "IfLess" or programparam1 = "IfLessOrEqual" or programparam1 = "IfInString" or programparam1 = "IfNotInString") and programparam4 = "") or ((programparam1 = "IWA" or programparam1 = "IWNA" or programparam1 = "IWE" or programparam1 = "IWNE" or programparam1 = "IfWinActive" or programparam1 = "IfWinNotActive" or programparam1 = "IfWinExist" or programparam1 = "IfWinNotExist") and programparam6 = ""))
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					was_block = %is_block%
					is_if++
					last_was = %last_is%
					last_is = 1
					If Ifstatement() = 1
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
						If (SubStr(inputparameters, 1, 4) = "else")
						{
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							If (SubStr(inputparameters, 1, 2) = macroifloopblock)
							{
								If (InStr(inputparameters, macroifloopblockend) != 0)
									StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
								else
									inputparameters =
							}
							else if (InStr(inputparameters, macroseparator) !=0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
							else
								inputparameters =	
						}	
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						
					}
					else
					{
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							If (InStr(inputparameters, macroifloopblockend) != 0)
								StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
							else
								inputparameters =
						}
						else if (InStr(inputparameters, macroseparator) !=0)
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						else
							inputparameters =	
					}
					If (SubStr(inputparameters, 1, 4) = "else")
					{
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						If (SubStr(inputparameters, 1, 2) = macroifloopblock)
						{
							StringTrimLeft, inputparameters, inputparameters, 2
							is_block = 1
						}
						else
							is_block = 0
						input := inputparameters
						inputparameters := RunMacro(1,is_if,is_loop, is_block, last_is)
						last_is = %last_was%
						is_if--
						is_block = %was_block%
					}
					;MsgBox, if:%inputparameters%
					continue
				}
				
				;If programparam1 = else, needs to delete as if used than it would run before
				If programparam1 = else
				{
					If (InStr(inputparameters, macroifloopblockend) != 0 and InStr(inputparameters, "{") = 1)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+1
					else if (InStr(inputparameters, macroseparator) !=0)
						StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroseparator)
					else
						inputparameters =
				}
					
				;Run command if exists/allowed
				IfInString, workingcommands, %programparam1%|
				{
					If (programparam1 != "" and programparam1 != "break" and programparam1 != "continue")
					{
						GoSub, %programparam1%
					}
				}
				else if (RegExMatch(programparam1, "^\w*\s?\s?=") = 0 and RegExMatch(programparam1, "^\w*\s?\s?:=") = 0 and programparam1 != "}")
				{
					Send, %programvar%
					continue
				}
				
				;!!!!!!!!!!!Return when Return is used
				If programparam1 = Return
				{
					inputparameters =
					Return "return" ;Unclear!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				}
				
				;Will break or continue if in a loop
				If (programparam1 = "break" or programparam1 = "continue")
				{
					;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					If is_block > 0
					{
						If InStr(inputparameters, "}" . macroseparator) = 1
							StringTrimLeft, inputparameters, inputparameters, 2
						else
							StringTrimLeft, inputparameters, inputparameters, InStr(inputparameters, macroifloopblockend)+2
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
					}
					If is_loop > 0
					{
						If last_is = 1
							inputparameters := programparam1 . macroseparator . inputparameters
						;MsgBox, %inputparameters%`n%is_loop%%is_if%%is_block%%last_is%
						Return inputparameters
					}
				}
				
				;Used for var=Value or var:=value or var:=DllCall,.... and so on
				IfInString, programparam1, =
				{
					If (programparam0 = 1 or InStr(programparam1, "FileExist") or InStr(programparam1, "GetKeyState") or InStr(programparam1, "InStr") or InStr(programparam1, "RegExMatch") or InStr(programparam1, "RegExReplace") or InStr(programparam1, "SubStr") or InStr(programparam1, "StrLen") or InStr(programparam1, "WinActive") or InStr(programparam1, "WinExist") or InStr(programparam1, "Asc") or InStr(programparam1, "Chr") or InStr(programparam1, "DllCall") or InStr(programparam1, VarSetCapacity))
					{
						IfInString, programparam1, :=
						{
							StringReplace, programparam1, programparam1, :=, =
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							;MSgBox, %programparamvar1%`n%programparamvar2%
							If programparam2 =
							{
								%programparamvar1% := %programparamvar2%
							}
							else
							{
								If programparamvar2 = FileExist
								{
									%programparamvar1% := FileExist(programparam2)
								}
								else if programparamvar2 = GetKeyState
								{
									%programparamvar1% := GetKeyState(programparam2,programparam3)
								}
								else if programparamvar2 = InStr
								{
									MsgBox, 1: %programparam1%`n2: %programparam2%`n2: %programparam3%`n2: %programparam4%
									%programparamvar1% := InStr(%programparam2%, programparam3,programparam4, programparam5)
								}
								else if programparamvar2 = RegExMatch
								{
									%programparamvar1% := RegExMatch(%programparam2%, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = RegExReplace
								{
									%programparamvar1% := RegExReplace(%programparam2%, programparam3, programparam4, programparam5, programparam6, programparam7)
								}
								else if programparamvar2 = SubStr
								{
									%programparamvar1% := SubStr(programparam2, programparam3, programparam4)
								}
								else if programparamvar2 = StrLen
								{
									%programparamvar1% := StrLen(programparam2)
								}
								else if programparamvar2 = WinActive
								{
									%programparamvar1% := WinActive(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = WinExist
								{
									%programparamvar1% := WinExist(programparam2, programparam3, programparam4, programparam5)
								}
								else if programparamvar2 = Asc
								{
									%programparamvar1% := Asc(programparam2)
								}
								else if programparamvar2 = Chr
								{
									%programparamvar1% := Chr(programparam2)
								}
								else if programparamvar2 = DllCall
								{
									If programparam0 = 20
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19, programparam20)
								  }
								  else if programparam0 = 19
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19)
								  }
								  else if programparam0 = 18
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18)
								  }
								  else if programparam0 = 17
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17)
								  }
								  else if programparam0 = 16
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16)
								  }
								  else if programparam0 = 15
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15)
								  }
								  else if programparam0 = 14
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14)
								  }
								  else if programparam0 = 13
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13)
								  }
								  else if programparam0 = 12
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12)
								  }
								  else if programparam0 = 11
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11)
								  }
								  else if programparam0 = 10
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10)
								  }
								  else if programparam0 = 9
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9)
								  }
								  else if programparam0 = 8
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8)
								  }
								  else if programparam0 = 7
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7)
								  }
								  else if programparam0 = 6
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5, programparam6)
								  }
								  else if programparam0 = 5
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4, programparam5)
								  }
								  else if programparam0 = 4
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3, programparam4)
								  }
								  else if programparam0 = 3
									{
								  	%programparamvar1% := DllCall( programparam2, programparam3)
								  }
								  else if programparam0 = 2
									{
								  	%programparamvar1% := DllCall( programparam2)
								  }
								}
								else if programparamvar2 = VarSetCapacity
								{
									%programparamvar1% := VarSetCapacity(%programparam2%, programparam3, programparam4)
								}
							}
						}
						else
						{
							StringSplit, programparamvar, programparam1, =, %A_Space%%A_Tab%
							%programparamvar1% = %programparamvar2%
						}
					}
				}
				
				If (last_is > 0 and is_block = 0)
					break
			}
		}
	}
	Return inputparameters
}









;____________________________________
;#Include commands.txt
1Include_commands:
AT:
AutoTrim:
  AutoTrim, %programparam2%
Return

BI:
BlockInput:
	BlockInput, %programparam2%
Return

C:
Click:
	Click %programparam2%, %programparam3%, %programparam4%
Return

CW:
ClipWait:
  ClipWait, %programparam2%, %programparam3%
  Error_Level = %Errorlevel%
Return

CTRL:
Control:
  Control, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
	Error_Level = %Errorlevel%
Return

CC:
ControlClick:
  ControlClick, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
	Error_Level = %Errorlevel%
Return

CF:
ControlFocus:
  ControlFocus, %programparam2%, %programparam3%, %programparam4%, %programparam5%
  Error_Level = %Errorlevel%
Return

CG:
ControlGet:
  ControlGet, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
	Error_Level = %Errorlevel%
Return

CGF:
ControlGetFocus:
  ControlGetFocus, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
	Error_Level = %Errorlevel%
Return

CGP:
ControlGetPos:
	ControlGetPos, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%, %programparam10%
Return

CMO:
ControlMove:
	ControlMove, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%, %programparam10%
	Error_Level = %Errorlevel%
Return

CGT:
ControlGetText:
  ControlGetText, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
	Error_Level = %Errorlevel%
Return

CS:
ControlSend:
  ControlSend, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
	Error_Level = %Errorlevel%
Return

CSR:
ControlSendRaw:
  ControlSendRaw, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
  Error_Level = %Errorlevel%
Return

CST:
ControlSetText:
  ControlSetText, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
	Error_Level = %Errorlevel%
Return

CM:
CoordMode:
  CoordMode, %programparam2%, %programparam3%
Return

CR:
Critical:
	Critical, %programparam2%
Return

DHT:
DetectHiddenText:
  DetectHiddenText, %programparam2%
Return

DHW:
DetectHiddenWindows:
  DetectHiddenWindows, %programparam2%
Return

DC:
DllCall:
	If programparam0 = 20
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19, programparam20)
  }
  else if programparam0 = 19
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18, programparam19)
  }
  else if programparam0 = 18
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17, programparam18)
  }
  else if programparam0 = 17
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16, programparam17)
  }
  else if programparam0 = 16
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15, programparam16)
  }
  else if programparam0 = 15
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14, programparam15)
  }
  else if programparam0 = 14
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13, programparam14)
  }
  else if programparam0 = 13
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12, programparam13)
  }
  else if programparam0 = 12
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11, programparam12)
  }
  else if programparam0 = 11
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10, programparam11)
  }
  else if programparam0 = 10
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9, programparam10)
  }
  else if programparam0 = 9
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8, programparam9)
  }
  else if programparam0 = 8
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7, programparam8)
  }
  else if programparam0 = 7
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6, programparam7)
  }
  else if programparam0 = 6
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5, programparam6)
  }
  else if programparam0 = 5
	{
  	DllCall( programparam2, programparam3, programparam4, programparam5)
  }
  else if programparam0 = 4
	{
  	DllCall( programparam2, programparam3, programparam4)
  }
  else if programparam0 = 3
	{
  	DllCall( programparam2, programparam3)
  }
  else if programparam0 = 2
	{
  	DllCall( programparam2)
  }
	Error_Level = %Errorlevel%
Return

D:
Drive:
  Drive, %programparam2%, %programparam3%, %programparam4%
	Error_Level = %Errorlevel%
Return

DG:
DriveGet:
  DriveGet, %programparam2%, %programparam3%, %programparam4%
	Error_Level = %Errorlevel%
Return

DSF:
DriveSpaceFree:
	DriveSpaceFree, %programparam2%, %programparam3%
Return

ES:
EnvSet:
  EnvSet, %programparam2%, %programparam3%
	Error_Level = %Errorlevel%
Return

EG:
EnvGet:
  EnvGet, %programparam2%, %programparam3%
Return

EU:
EnvUpdate:
  EnvUpdate
  Error_Level = %Errorlevel%
Return

ESU:
EnvSub:
  EnvSub, %programparam2%, %programparam3%
Return

EA:
EnvAdd:
  EnvAdd, %programparam2%, %programparam3%
Return

ED:
EnvDiv:
  EnvDiv, %programparam2%, %programparam3%
Return

EM:
EnvMult:
  EnvMult, %programparam2%, %programparam3%
Return

E:
Exit:
	ToolTip, , , , 20
	Loop
	{
		If runningprograms = 0
		{
			tooltippos = 0
			break
		}
		ToolTip,,,, %runningprograms%
		runningprograms--
		If runningprograms > 0
			tooltippos -= 14
	}
  Exit, %programparam2%
Return

EAP:
ExitApp:
  ExitApp
Return

FA:
FileAppend:
  FileAppend, %programparam2%, %programparam3%
  Error_Level = %Errorlevel%
Return

FC:
FileCopy:
  FileCopy, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

FCD:
FileCopyDir:
  FileCopyDir, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

FCDIR:
FileCreateDir:
  FileCreateDir, %programparam2%
  Error_Level = %Errorlevel%
Return

FCS:
FileCreateShortcut:
	FileCreateShortcut, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%, %programparam10%
	Error_Level = %Errorlevel%
Return

FD:
FileDelete:
  FileDelete, %programparam2%
  Error_Level = %Errorlevel%
Return

FGA:
FileGetAttrib:
  FileGetAttrib, %programparam2%, %programparam3%
  Error_Level = %Errorlevel%
Return

FGS:
FileGetSize:
  FileGetSize, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

FGSH:
FileGetShortcut:
	FileGetShortcut, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
	Error_Level = %Errorlevel%
Return

FGT:
FileGetTime:
  FileGetTime, %programparam2%, %programparam3%, %programparam3%
  Error_Level = %Errorlevel%
Return

FGV:
FileGetVersion:
	FileGetVersion, %programparam2%, %programparam3%
	Error_Level = %Errorlevel%
Return

FM:
FileMove:
  FileMove, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

FMD:
FileMoveDir:
  FileMoveDir, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

FR:
FileRead:
  FileRead, %programparam2%, %programparam3%
  Error_Level = %Errorlevel%
Return

FRL:
FileReadLine:
  FileReadLine, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

FRC:
FileRecycle:
	FileRecycle, %programparam2%
	Error_Level = %Errorlevel%
Return

FRE:
FileRecycleEmpty:
	FileRecycleEmpty, %programparam2%
	Error_Level = %Errorlevel%
Return

FRD:
FileRemoveDir:
	FileRemoveDir, %programparam2%, %programparam3%
	Error_Level = %Errorlevel%
Return

FSD:
FileSelectFile:
  FileSelectFile, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

FSF:
FileSelectFolder:
  FileSelectFolder, %programparam2%, %programparam3%, %programparam4%, %programparam5%
  Error_Level = %Errorlevel%
Return

FSA:
FileSetAttrib:
  FileSetAttrib, %programparam2%, %programparam3%, %programparam4%, %programparam5%
  Error_Level = %Errorlevel%
Return

FST:
FileSetTime:
  FileSetTime, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

FT:
FormatTime:
  FormatTime, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

GKS:
GetKeyState:
	GetKeyState, %programparam2%, %programparam3%, %programparam4%
Return

GA:
GroupActivate:
  GroupActivate, %programparam2%, %programparam3%
Return

GADD:
GroupAdd:
  GroupAdd, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
Return

GCL:
GroupClose:
  GroupClose, %programparam2%, %programparam3%
Return

H:
Hotkey:
	Hotkey, %programparam2%, %programparam3%, %programparam4%
	Error_Level = %Errorlevel%
Return

GS:
GoSub:
	GoSub, %programparam2%
Return

GT:
GoTo:
	Goto, %programparam2%
Return

IMB:
IfMsgBox:
{
	IfMsgBox, %programparam2%
	{
		count = 3
		Loop 18
		{
			programparam%A_Index% := programparam%count%
			count++
		}
		IfInString, workingcommands, %programparam1%|
			GoSub, %programparam1%
		IfNotInString, programparam1, `%
		{
			out := programparam1
			If %out%2 =
			{
				out = ;!!!!!!!!!!!!
			}
			else
			{ 
				out := programparam1
				GoSub, Runvar
				Return
			}
		}
		IfInString, programparam1, `%
		{
			StringReplace, programsubtorun, programparam1, `%, , A
			;MsgBox % %programsubtorun%
			out := %programsubtorun%
			Sleep, 100
			If out is digit
			{
			}
			else
			{
				GoSub, Runvar
				Return
			}
		}
	}
Return
}

IEQ:
INEQ:
IG:
IGOE:
IL:
ILOE:
IIS:
INIS:
IWA:
IWNA:
IWE:
IWNE:
IE:
INE:
IfEqual:
IfNotEqual:
IfGreater:
IfGreaterOrEqual:
IfLess:
IfLessOrEqual:
IfInString:
IfNotInString:
IfWinActive:
IfWinNotActive:
IfWinExist:
IfWinNotExist:
IfExist:
IfNotExist:
{
	loopcount=
	If (programparam1 = "IfEqual" || programparam1 = "IEQ")
	{
		IfEqual, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfNotEqual" || programparam1 = "INEQ")
	{
		IfNotEqual, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfLess" || programparam1 = "IL")
	{
		IfLess, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfLessOrEqual" || programparam1 = "ILOE")
	{
		IfLessOrEqual, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfGreater" || programparam1 = "IG")
	{
		IfGreater, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfGreaterOrEqual" || programparam1 = "IGOE")
	{
		IfGreaterOrEqual, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfInString" || programparam1 = "IIS")
	{
		IfInString, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfNotInString" || programparam1 = "INIS")
	{
		IfNotInString, %programparam2%, %programparam3%
		{
			ifcount=4
			loopcount=17
			out = %programparam4%
			programparam0 -= 3
		}
		else
			Return
	}
	
	If (programparam1 = "IfWinActive" || programparam1 = "IWA")
	{
		IfWinActive, %programparam2%, %programparam3%, %programparam4%, %programparam5%
		{
			ifcount=6
			loopcount=15
			out = %programparam6%
			programparam0 -= 5
		}
		else
			Return
	}
	
	If (programparam1 = "IfWinNotActive" || programparam1 = "IWNA")
	{
		IfWinNotActive, %programparam2%, %programparam3%, %programparam4%, %programparam5%
		{
			ifcount=6
			loopcount=15
			out = %programparam6%
			programparam0 -= 5
		}
		else
			Return
	}
	
	If (programparam1 = "IfWinExist" || programparam1 = "IWE")
	{
		IfWinExist, %programparam2%, %programparam3%, %programparam4%, %programparam5%
		{
			ifcount=6
			loopcount=15
			out = %programparam6%
			programparam0 -= 5
		}
		else
			Return
	}
	
	If (programparam1 = "IfWinNotExist" || programparam1 = "IWNE")
	{
		IfWinNotExist, %programparam2%, %programparam3%, %programparam4%, %programparam5%
		{
			ifcount=6
			loopcount=15
			out = %programparam6%
			programparam0 -= 5
		}
		else
			Return
	}
	
	If (programparam1 = "IfExist" || programparam1 = "IE")
	{
		IfExist, %programparam2%
		{
			ifcount=3
			loopcount=18
			out = %programparam3%
			programparam0 -= 2
		}
		else
			Return
	}
	If (programparam1 = "IfNotExist" || programparam1 = "INE")
	{
		IfNotExist, %programparam2%
		{
			ifcount=3
			loopcount=18
			out = %programparam3%
			programparam0 -= 2
		}
		else
			Return
	}
	Loop %loopcount%
	{
		;MsgBox % programparam%A_Index% programparam%ifcount%
		programparam%A_Index% := programparam%ifcount%
		;MsgBox % programparam%A_Index%
		ifcount++
	}
	If out is alnum
	{
		If %out%2 = 
		{
			out=
		}
		else
		{
			If programparam0 = 1
			{
				RunVar()
				Return
			}
		}
	}
	else
		out =
	If loopcount =
		Return
	;MsgBox % programparam1
	IfInString, workingcommands, %programparam1%|
	{
		If (programparam1 != "continue" and programparam1 != "break")
		GoSub, %programparam1%
	}
	loopcount=
	;If programparam1 = Return
	;wantreturn = 1
	Return
}

KW:
KeyWait:
  KeyWait, %programparam2%, %programparam3%
  Error_Level = %Errorlevel%
Return

M:
Menu:
  Menu, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

MC:
MouseClick:
  MouseClick, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%
Return

MCD:
MouseClickDrag:
  MouseClickDrag, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%
Return

MGP:
MouseGetPos:
	MouseGetPos, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

MM:
MouseMove:
  MouseMove, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

MB:
MsgBox:
	SetEnv, checkifmsgboxfull, %programparam3%%programparam4%%programparam5%
	IfNotEqual, checkifmsgboxfull, , SetEnv, checkifmsgboxfull, 1
	If programparam2 is digit
	{
		If checkifmsgboxfull = 1 
		{
				;MsgBox % programparam2
				If programparam2 < 1
					MsgBox, 0, %programparam3%, %programparam4%, %programparam5%
				else if programparam2 = 1
				{
					MsgBox, 1, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 2
				{
					MsgBox, 2, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 3
				{
					MsgBox, 3, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 4
				{
					MsgBox, 4, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 5
				{
					MsgBox, 5, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 6
				{
					MsgBox, 6, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 262144
				{
					MsgBox, 262144, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 262145
				{
					MsgBox, 262145, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 262146
				{
					MsgBox, 262146, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 262147
				{
					MsgBox, 262147, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 262148
				{
					MsgBox, 262148, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 262149
				{
					MsgBox, 262149, %programparam3%, %programparam4%, %programparam5%
				}
				else if programparam2 = 262150
				{
					MsgBox, 262150, %programparam3%, %programparam4%, %programparam5%
				}
		}
		else
		{
			MsgBox, %programparam2% %programparam3% %programparam4% %programparam5% %programparam6% %programparam7% %programparam8% %programparam9% %programparam10% %programparam11% %programparam12% %programparam13% %programparam14% %programparam15% %programparam16% %programparam17% %programparam18% %programparam19% %programparam20%
		}
	}
	else
  {
  	MsgBox, %programparam2% %programparam3% %programparam4% %programparam5% %programparam6% %programparam7% %programparam8% %programparam9% %programparam10% %programparam11% %programparam12% %programparam13% %programparam14% %programparam15% %programparam16% %programparam17% %programparam18% %programparam19% %programparam20%
  }
Return

OE:
OnExit:
  OnExit, %programparam2%
Return

PGC:
PixelGetColor:
  PixelGetColor, %programparam2%, %programparam3%, %programparam4%, %programparam5%
  Error_Level = %Errorlevel%
Return

PS:
PixelSearch:
  PixelSearch, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%, %programparam10%
  Error_Level = %Errorlevel%
Return

PWC:
PixelWaitColor:  ;(ByRef programparam2, ByRef programparam3, p_x1, p_y1, p_x2, p_y2, p_color, p_shades="", p_opts="", p_waitms=0, p_checkinterval="")
{
	if (RegExMatch(programparam8, "i)^[0-9a-f]{6}$"))
		programparam8:="0x" programparam8
	programparam8_bkp:=programparam8
	programparam8:=RegExReplace(programparam8, "i)\bSlow\b")
	if (programparam8=programparam8_bkp)
		programparam8:=programparam8 " Fast"
	programparam8_bkp:=programparam8
	programparam8:=RegExReplace(programparam8, "i)\bBGR\b")
	if (programparam8=programparam8_bkp)
		programparam8:=programparam8 " RGB"
	if (programparam12="")
		programparam12=519
	ts:=A_TickCount
	Loop 
	{
		PixelSearch, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%, %programparam10%
		if (errorlevel=0 || programparam11 && A_TickCount-ts>=programparam11)
			break
		if (programparam11 && (A_TickCount-ts)+programparam12>=programparam11)
			programparam12:=(programparam11-(A_TickCount-ts))/2
		if (programparam12>19)
			Sleep, %programparam12%
	}
	Return
}

PR:
Process:
  Process, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %ErrorLevel%
Return

R:
Run:
  Run, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

RA:
RunAs:
	If programparam2 =
		RunAs
	else
  	RunAs, %programparam2%, %programparam3%, %programparam4%
Return

RW:
RunWait:
	If programparam5 =
		RunWait, %programparam2%, %programparam3%, %programparam4%
	else
	  RunWait, %programparam2%, %programparam3%, %programparam4%, %programparam5%
  Error_Level = %Errorlevel%
Return

SN:
Send:
  Send, %programparam2%
Return

SP:
SendPlay:
	SendPlay, %programparam2%
Return

SI:
SendInput:
	SendInput, %programparam2%
Return

SRAW:
SendRaw:
	SendRaw, %programparam2%
Return

SEV:
SendEvent:
	SendEvent, %programparam2%
Return

RND:
Random:
  Random, %programparam2%, %programparam3%, %programparam4%
Return

SE:
SetEnv:
  SetEnv, %programparam2%, %programparam3%
Return

SF:
SetFormat:
	SetFormat, %programparam2%, %programparam3%
Return

SMOD:
SendMode:
  SendMode, %programparam2%
Return

SKD:
SetKeyDelay:
  SetKeyDelay, %programparam2%, %programparam3%, %programparam4%
Return

SMD:
SetMouseDelay:
  SetMouseDelay, %programparam2%, %programparam3%
Return

STMM:
SetTitleMatchMode:
  SetTitleMatchMode, %programparam2%
Return

SWD:
SetWinDelay:
  SetWinDelay, %programparam2%
Return

SD:
Shutdown:
  Shutdown, %programparam2%
Return

S:
Sleep:
  Sleep, %programparam2%
Return

SO:
Sort:
  Sort, %programparam2%, %programparam3%
  If programparam3 = U
  	Error_Level = %Errorlevel%
Return

SPTH:
SplitPath:
  SplitPath, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
Return

SBGT:
StatusBarGetText:
  StatusBarGetText, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
  Error_Level = %Errorlevel%
Return

SBW:
StatusBarWait:
  StatusBarWait, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
  Error_Level = %Errorlevel%
Return

SCS:
StringCaseSense:
  StringCaseSense, %programparam2%
Return

SGP:
StringGetPos:
  StringGetPos, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

SL:
StringLeft:
  StringLeft, %programparam2%, %programparam3%, %programparam4%
Return

SLEN:
StringLen:
  StringLen, %programparam2%, %programparam3%
Return

SLOW:
StringLower:
  StringLower, %programparam2%, %programparam3%, %programparam4%
Return

SM:
StringMid:
  StringMid, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

SRPL:
StringReplace:
  StringReplace, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

SR:
StringRight:
  StringRight, %programparam2%, %programparam3%, %programparam4%
Return

SS:
StringSplit:
  StringSplit, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

STL:
StringTrimLeft:
  StringTrimLeft, %programparam2%, %programparam3%, %programparam4%
Return

STR:
StringTrimRight:
  StringTrimRight, %programparam2%, %programparam3%, %programparam4%
Return

SUP:
StringUpper:
  StringUpper, %programparam2%, %programparam3%, %programparam4%
Return

SG:
SysGet:
  SysGet, %programparam2%, %programparam3%, %programparam4%
Return

TT:
ToolTip:
  ToolTip, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

TRT:
TrayTip:
  TrayTip, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

TR:
Transform:
  Transform, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

UDTF:
UrlDownloadToFile:
  UrlDownloadToFile, %programparam2%, %programparam3%
  Error_Level = %Errorlevel%
Return

VSC:
VarSetCapacity:
	VarSetCapacity(%programparam2%, programparam3, programparam4)
Return

WA:
WinActivate:
  WinActivate, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

WAB:
WinActivateBottom:
  WinActivateBottom, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

WC:
WinClose:
  WinClose, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

WGAT:
WinGetActiveTitle:
  WinGetActiveTitle, %programparam2%
Return

WGC:
WinGetClass:
  WinGetClass, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

WG:
WinGet:
  WinGet, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

WGP:
WinGetPos:
  WinGetPos, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
Return

WGT:
WinGetText:
  WinGetText, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

WGTT:
WinGetTitle:
  WinGetTitle, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

WH:
WinHide:
  WinHide, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

WK:
WinKill:
  WinKill, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

WMSI:
WinMenuSelectItem:
  WinMenuSelectItem, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%, %programparam10%, %programparam11%, %programparam12%
  Error_Level = %Errorlevel%
Return

WM:
WinMove:
  WinMove, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
Return

WSH:
WinShow:
  WinShow, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

WS:
WinSet:
  WinSet, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
  If (programparam2 = "Style" or programparam2 = "Exstyle" or programparam2 = Polygon)
  	Error_Level = %Errorlevel%
Return

WST:
WinSetTitle:
  WinSetTitle, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

WW:
WinWait:
  WinWait, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

WWA:
WinWaitActive:
  WinWaitActive, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

WWC:
WinWaitClose:
  WinWaitClose, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

WWNA:
WinWaitNotActive:
  WinWaitNotActive, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
  Error_Level = %Errorlevel%
Return

WMAX:
WinMaximize:
  WinMaximize, %programparam2%, %programparam3%, %programparam4%
Return

WMIN:
WinMinimize:
  WinMinimize, %programparam2%, %programparam3%, %programparam4%
Return

WR:
WinRestore:
  WinRestore, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

IS:
ImageSearch:
  ImageSearch, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%
  Error_Level = %Errorlevel%
Return

ID:
IniDelete:
  IniDelete, %programparam2%, %programparam3%, %programparam4%
  Error_Level = %Errorlevel%
Return

IR:
IniRead:
  IniRead, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

IW:
IniWrite:
  IniWrite, %programparam2%, %programparam3%, %programparam4%, %programparam5%
  Error_Level = %Errorlevel%
Return

I:
Input:
  Input, %programparam2%, %programparam3%, %programparam4%, %programparam5%
  Error_Level = %Errorlevel%
Return

IB:
InputBox:
  InputBox, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%, , %programparam11%, %programparam12%
  Error_Level = %Errorlevel%
Return

G:
Gui:
	Gui, %programparam2%, %programparam3%, %programparam4%, %programparam5%
Return

GD:
GroupDeactivate:
	GroupDeactivate, %programparam2%, %programparam3%
Return

GC:
GuiControl:
	GuiControl, %programparam2%, %programparam3%, %programparam4%
	Error_Level = %Errorlevel%
Return

GuiControlGet:
	GuiControlGet, %programparam2%, %programparam3%, %programparam4%, %programparam5%
	Error_Level = %Errorlevel%
Return

If:
	If programparam3 = is
	{
		If %programparam2% is %programparam4%
		{
			GoSub, RunCommand
		}
	}
	else if programparam3 = is not
	{
		If %programparam2% is not %programparam4%
		{
			GoSub, RunCommand
		}
	}
	else If programparam3 = <
	{
		If %programparam2% < %programparam4%
		{
			GoSub, RunCommand
		}
	}
	else If programparam3 = =
	{
		If %programparam2% = %programparam4%
		{
			GoSub, RunCommand
		}
	}
	else If programparam3 = >
	{
		If %programparam2% > %programparam4%
		{
			GoSub, RunCommand
		}
	}
Return

Ifstatement()
{
	global
	If (programparam1 = "IfMsgBox" || programparam1 = "IMB")
	{
		IfMsgBox, %programparam2%
			Return 1
		else
			Return
	}
	If (programparam1 = "IfEqual" || programparam1 = "IEQ")
	{
		IfEqual, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	If (programparam1 = "IfNotEqual" || programparam1 = "INEQ")
	{
		IfNotEqual, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfLess" || programparam1 = "IL")
	{
		IfLess, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfLessOrEqual" || programparam1 = "ILOE")
	{
		IfLessOrEqual, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfGreater" || programparam1 = "IG")
	{
		IfGreater, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfGreaterOrEqual" || programparam1 = "IGOE")
	{
		IfGreaterOrEqual, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfInString" || programparam1 = "IIS")
	{
		IfInString, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfNotInString" || programparam1 = "INIS")
	{
		IfNotInString, %programparam2%, %programparam3%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfWinActive" || programparam1 = "IWA")
	{
		IfWinActive, %programparam2%, %programparam3%, %programparam4%, %programparam5%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfWinNotActive" || programparam1 = "IWNA")
	{
		IfWinNotActive, %programparam2%, %programparam3%, %programparam4%, %programparam5%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfWinExist" || programparam1 = "IWE")
	{
		IfWinExist, %programparam2%, %programparam3%, %programparam4%, %programparam5%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfWinNotExist" || programparam1 = "IWNE")
	{
		IfWinNotExist, %programparam2%, %programparam3%, %programparam4%, %programparam5%
			Return 1
		else
			Return
	}
	
	If (programparam1 = "IfExist" || programparam1 = "IE")
	{
		IfExist, %programparam2%
			Return 1
		else
			Return
	}
	If (programparam1 = "IfNotExist" || programparam1 = "INE")
	{
		IfNotExist, %programparam2%
			Return 1
		else
			Return
	}
	If programparam3 = is
	{
		If %programparam2% is %programparam4%
			Return 1
	}
	else if programparam3 = is not
	{
		If %programparam2% is not %programparam4%
			Return 1
	}
	else If programparam3 = <
	{
		If %programparam2% < %programparam4%
			Return 1
	}
	else If programparam3 = =
	{
		If %programparam2% = %programparam4%
			Return 1
	}
	else If programparam3 = >
	{
		If %programparam2% > %programparam4%
			Return 1
	}
	Return
}

RunCommand:
	count = 5
	Loop 16
	{
		programparam%A_Index% := programparam%count%
		count++
	}
	;If programparam1 =
	;{
	;	MSgBox input: %inputparameters%
	;	input = %inputparameters%
	;	inputparameters =
	;	inputparameters := Sendkeysnew(1)
	;	MsgBox, input: %inputparameters%
	;}
	;else
	;{
	IfInString, workingcommands, %programparam1%|
	GoSub, %programparam1%
	;}
Return

KH:
KeyHistory:
	KeyHistory
Return

LH:
ListHotkeys:
	ListHotkeys
Return

LV:
ListVars:
	ListVars
Return

OD:
OutputDebug:
	OutputDebug, %programparam2%
Return

P:
Pause:
	Pause, %programparam2%, %programparam3%
Return

PM:
PostMessage:
	PostMessage, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
	Error_Level = %Errorlevel%
Return

SMSG:
SendMessage:
	SendMessage, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%, %programparam8%, %programparam9%
	Error_Level = %Errorlevel%
Return

PRG:
Progress:
	Progress, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

SIM:
SplashImage:
	SplashImage, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%
Return

RD:
RegDelete:
	Regdelete, %programparam2%, %programparam3%, %programparam4%
	Error_Level = %Errorlevel%
Return

REM:
RegExMatch:
	RegExMatch(%programparam2%, %programparam3%, %programparam4%, %programparam5%)
	Error_Level = %Errorlevel%
Return

RER:
RegExReplace:
	RegExReplace(%programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%, %programparam7%)
	Error_Level = %Errorlevel%
Return

RC:
RegisterCallback:
	RegisterCallback(%programparam2%, %programparam3%, %programparam4%, %programparam5%)
Return

RR:
RegRead:
	RegRead, %programparam2%, %programparam3%, %programparam4%, %programparam5%
	Error_Level = %Errorlevel%
Return

RWR:
RegWrite:
	RegWrite, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%^
	Error_Level = %Errorlevel%
Return

RL:
Reload:
	Reload
Return

SBL:
SetBatchLines:
	SetBatchLines, %programparam2%
Return

SCD:
SetControlDelay:
	SetControlDelay, %programparam2%
Return

SDMS:
SetDefaultMouseSpeed:
	SetDefaultMouseSpeed, %programparam2%
Return

SNLS:
SetNumLockState:
 SetNumLockState, %programparam2%
Return

SCLS:
SetCapsLockState:
	SetCapsLockState, %programparam2%
Return

SSLS:
SetScrollLockState:
	SetScrollLockState, %programparam2%
Return

SSCM:
SetStoreCapslockMode:
	SetStoreCapslockMode, %programparam2%
Return

ST:
SetTimer:
	SetTimer, %programparam2%, %programparam3%, %programparam4%
Return

SWDIR:
SetWorkingDir:
	SetWorkingDir, %programparam2%
	Error_Level = %Errorlevel%
Return

SB:
SoundBeep:
	SoundBeep, %programparam2%, %programparam3%
Return

SOG:
SoundGet:
	SoundGet, %programparam2%, %programparam3%, %programparam4%, %programparam5%
	Error_Level = %Errorlevel%
Return

SGWV:
SoundGetWaveVolume:
	SoundGetWaveVolume, %programparam2%, %programparam3%, %programparam4%
	Error_Level = %Errorlevel%
Return

SPL:
SoundPlay:
	SoundPlay, %programparam2%, %programparam3%
	Error_Level = %Errorlevel%
Return

SOS:
SoundSet:
	SoundSet, %programparam2%, %programparam3%, %programparam4%, %programparam5%
	Error_Level = %Errorlevel%
Return

SSWV:
SoundSetWaveVolume:
	SoundSetWaveVolume, %programparam2%, %programparam3%
	Error_Level = %Errorlevel%
Return

STOF:
SplashTextOff:
	SplashTextOff
Return

STON:
SplashTextOn:
	SplashTextOn, %programparam2%, %programparam3%, %programparam4%, %programparam5% 
Return

SU:
Suspend:
	Suspend, %programparam2%
Return

T:
Thread:
	Thread, %programparam2%, %programparam3%
Return

WGAS:
WinGetActiveStats:
	WinGetActiveStats, %programparam2%, %programparam3%, %programparam4%, %programparam5%, %programparam6%
Return

WMA:
WinMinimizeAll:
	WinMinimizeAll
Return

WMAU:
WinMinimizeAllUndo:
	WinMinimizeAllUndo
Return







;_________________________________________
;#Include winhider.txt
1Inlcude_winhider:
mwt_Minimize:
{
	ToolTip
	if mwt_WindowCount >= %mwt_MaxWindows%
	{
	    MsgBox No more than %mwt_MaxWindows% may be hidden simultaneously.
	    return
	}
	WinWait, A,, 2
	if ErrorLevel <> 0  ; It timed out, so do nothing.
	    return
	WinGet, mwt_ActiveID, ID
	WinGetTitle, mwt_ActiveTitle
	WinGetClass, mwt_ActiveClass
	if mwt_ActiveClass in Shell_TrayWnd,Progman
	{
	    MsgBox The desktop and taskbar cannot be hidden.
	    return
	}
	Send, !{esc}
	WinHide
	if mwt_ActiveTitle =
	    mwt_ActiveTitle = ahk_class %mwt_ActiveClass%
	StringLeft, mwt_ActiveTitle, mwt_ActiveTitle, %mwt_MaxLength%
	Loop, %mwt_MaxWindows%
	{
	    if mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
	    {
	        ; Match found, so it's not unique.
	        ; First remove the 0x from the hex number to conserve menu space:
	        StringTrimLeft, mwt_ActiveIDShort, mwt_ActiveID, 2
	        StringLen, mwt_ActiveIDShortLength, mwt_ActiveIDShort
	        StringLen, mwt_ActiveTitleLength, mwt_ActiveTitle
	        mwt_ActiveTitleLength += %mwt_ActiveIDShortLength%
	        mwt_ActiveTitleLength++ ; +1 the 1 space between title & ID.
	        if mwt_ActiveTitleLength > %mwt_MaxLength%
	        {
	            ; Since menu item names are limted in length, trim the title
	            ; down to allow just enough room for the Window's Short ID at
	            ; the end of its name:
	            TrimCount = %mwt_ActiveTitleLength%
	            TrimCount -= %mwt_MaxLength%
	            StringTrimRight, mwt_ActiveTitle, mwt_ActiveTitle, %TrimCount%
	        }
	        ; Build unique title:
	        mwt_ActiveTitle = %mwt_ActiveTitle% %mwt_ActiveIDShort%
	        break
	    }
	}
	mwt_AlreadyExists = n
	Loop, %mwt_MaxWindows%
	{
	    if mwt_WindowID%a_index% = %mwt_ActiveID%
	    {
	        mwt_AlreadyExists = y
	        break
	    }
	}
	if mwt_AlreadyExists = n
	{
	    Menu, Tray, add, %mwt_ActiveTitle%, RestoreFromTrayMenu
	    mwt_WindowCount++
	    Loop, %mwt_MaxWindows%  ; Search for a free slot.
	    {
	        ; It should always find a free slot if things are designed right.
	        if mwt_WindowID%a_index% =  ; An empty slot was found.
	        {
	            mwt_WindowID%a_index% = %mwt_ActiveID%
	            mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
	            break
	        }
	    }
	}
	return
}

RestoreFromTrayMenu:
{
	Menu, Tray, delete, %A_ThisMenuItem%
	; Find window based on its unique title stored as the menu item name:
	Loop, %mwt_MaxWindows%
	{
	    if mwt_WindowTitle%a_index% = %A_ThisMenuItem%  ; Match found.
	    {
	        StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
	        WinShow, ahk_id %IDToRestore%
	        WinActivate ahk_id %IDToRestore%  ; Sometimes needed.
	        mwt_WindowID%a_index% =  ; Make it blank to free up a slot.
	        mwt_WindowTitle%a_index% =
	        mwt_WindowCount--
	        break
	    }
	}
	return
}



mwt_UnMinimize:
{
	if mwt_WindowCount > 0 
	{
	    ;; Get the id of the last window minimized and unhide it
	    StringTrimRight, IDToRestore, mwt_WindowID%mwt_WindowCount%, 0
	    WinShow, ahk_id %IDToRestore%
	    WinActivate ahk_id %IDToRestore%
	    
	    ;; Get the menu name of the last window minimized and remove it
	    StringTrimRight, MenuToRemove, mwt_WindowTitle%mwt_WindowCount%, 0
	    Menu, Tray, delete, %MenuToRemove%
	    
	    ;; clean up our 'arrays' and decrement the window count
	    mwt_WindowID%mwt_WindowCount% =
	    mwt_WindowTitle%mwt_WindowCount% = 
	    mwt_WindowCount--
	}
	return
}

mwt_RestoreAllThenExit:
{
	DllCall("gdi32.dll\DeleteObject", UInt,h_region )
	DllCall("gdi32.dll\DeleteObject", UInt,hbm_buffer)
	DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
  DllCall("gdi32.dll\DeleteDC", UInt,hdc_buffer)
  Gosub, RestoreAll
	Gosub, mwt_RestoreAll
	ExitApp  ; Do a true exit.
}


mwt_RestoreAll:
{
Loop, %mwt_MaxWindows%
{
    if mwt_WindowID%a_index% <>
    {
        StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
        WinShow, ahk_id %IDToRestore%
        WinActivate ahk_id %IDToRestore%  ; Sometimes needed.
        ; Do it this way vs. DeleteAll so that the sep. line and first
        ; item are retained:
        StringTrimRight, MenuToRemove, mwt_WindowTitle%a_index%, 0
        Menu, Tray, delete, %MenuToRemove%
        mwt_WindowID%a_index% =  ; Make it blank to free up a slot.
        mwt_WindowTitle%a_index% =
        mwt_WindowCount--
    }
    if mwt_WindowCount = 0
        break
}
return
}









;________________________________
;#Include winspy.txt
1Include_winspy:
CAPSLOCK & F6::

MouseGetPos, MousePosX, MousePosY, CurrentWinID
CoordMode, Mouse, Screen
MouseGetPos, MousePosScreenX, MousePosScreenY, CurrentWinID, ControlName

WinGetTitle, CurrentWin, ahk_ID %CurrentWinID%

SetTitleMatchMode, Slow
WinGetTitle, CurrentWinSlow, ahk_ID %CurrentWinID%
SetTitleMatchMode, Fast

WinGetClass, CurrentWinClass, ahk_ID %CurrentWinID%

;------------------------------------------------------

Menu, Title, add, %CurrentWin%, WinSub_Title
;Menu, Title, add, %CurrentWinSlow% (match=slow), WinSub_TitleSlow
Menu, Title, add, ahk_Class %CurrentWinClass%, WinSub_Class
Menu, Title, add, ahk_id %CurrentWinID%, WinSub_ID
Menu, Main, add, &Window Title, :Title

;------------------------------------------------------

WinGetPos, CurrentWinX, CurrentWinY, CurrentWinW, CurrentWinH, %CurrentWin%

Menu, WinPos, add, X: %CurrentWinX% %a_tab% Y: %CurrentWinY%, WinSub_XY
Menu, WinPos, add, W: %CurrentWinW% %a_tab% H: %CurrentWinH% , WinSub_WH
Menu, Main, add, Window &Position, :WinPos

;------------------------------------------------------

WinGetText, WinText, %CurrentWin%

if WinText=
Menu, Text, add, No Text Found, WinSub_Text

StringSplit, WinTextShort, WinText, `n

Loop, %WinTextShort0%
{
  StringTrimLeft, NewLine, WinTextShort%a_index%, 0

  if NewLine=
    continue

  if (strlen(NewLine) > 100)
  {
    StringLeft, NewLine, NewLine, 100
    NewLine=%NewLine% ---8<---
  }

  Menu, Text, add, %NewLine%, WinSub_Text

  if a_index>15
  {
    Menu, Text, add, -------------8<-------------, WinSub_Text
    break
  }
}

Menu, Main, add, Window &Text, :Text
Menu, Main, add

;------------------------------------------------------

loop, 5
{
  StatusBarGetText, Part, %a_index%, %CurrentWin%
  if Part <>
  {
    x=1
    Menu, Status, add, %a_index%) %Part%, StatusSub
  }
}

if x <> 1
Menu, Status, add, No Text Found, Status

Menu, Main, add, &Status Bar, :Status

;------------------------------------------------------

Menu, MousePos, add, Screen, MouseSub_ScreenXY
Menu, MousePos, add, &X: %MousePosScreenX% %a_tab% Y: %MousePosScreenY%, MouseSub_ScreenXY
Menu, MousePos, add
Menu, MousePos, add, Window, MouseSub_WindowXY
Menu, MousePos, add, X: %MousePosX% %a_tab% &Y: %MousePosY%, MouseSub_WindowXY
Menu, Main, add, &Mouse Position, :MousePos

;------------------------------------------------------

ControlGetPos, ControlPosX, ControlPosY, ControlPosW, ControlPosH, %ControlName%, %CurrentWin%
ControlGetText, ControlText, %ControlName%, %CurrentWin%

if ControlText=
Menu, ControlText, add, No Text Found, ControlSub_Text

StringSplit, ControlTextShort, ControlText, `n
Loop, %ControlTextShort0%
{
  StringTrimLeft, NewLine, ControlTextShort%a_index%, 0

  if NewLine=
    continue

  if (strlen(NewLine) > 100)
  {
    StringLeft, NewLine, NewLine, 100
    NewLine=%NewLine% ---8<---
  }
  Menu, ControlText, add, %NewLine%, ControlSub_Text

  if a_index=10
  {
    Menu, ControlText, add, -------------8<-------------, ControlSub_Text
    break
  }
}

Menu, Control, add, %ControlName%, ControlSub_Name
Menu, Control, add
Menu, Control, add, X: %ControlPosX% %a_tab% Y: %ControlPosY%, ControlSub_XY
Menu, Control, add, W: %ControlPosW% %a_tab% H: %ControlPosH%, ControlSub_WH
Menu, Control, add
Menu, Control, add, Text, :ControlText
Menu, Main, add, &Control, :Control

;------------------------------------------------------

PixelGetColor, PixelRGB, MousePosX, MousePosY, RGB
PixelGetColor, PixelBGR, MousePosX, MousePosY

x=3
loop, 3
{
  StringMid, HEX%a_index%, PixelRGB, %x%, 2
  x+=2
}

Menu, Colour, add, &RGB %PixelRGB%, PixelSub_HEX
Menu, Colour, add, &BGR %PixelBGR%, PixelBGRSub_HEX
Menu, Colour, add, % "R: " HEXtoDEC(HEX1) "   G: " HEXtoDEC(HEX2)"   B: " HEXtoDEC(HEX3), PixelSub_DEC
Menu, Main, add, Pi&xel Colour (RGB/BGR), :Colour

;------------------------------------------------------

Menu, Main, Show

;Clears Menus

Menu, Main, DeleteAll
Menu, Control, DeleteAll
Menu, ControlText, DeleteAll
Menu, MousePos, DeleteAll
Menu, WinPos, DeleteAll
Menu, Text, DeleteAll
Menu, Title, DeleteAll
Menu, Colour, DeleteAll
Menu, Status, DeleteAll

return

;------------------------------------------------------


WinSub_Title:
Clipboard=%CurrentWin%
return

WinSub_TitleSlow:
Clipboard=%CurrentWinSlow%
return

WinSub_Class:
Clipboard=AHK_class %CurrentWinClass%
return

WinSub_ID:
Clipboard=AHK_ID %CurrentWinID%
return

WinSub_XY:
Clipboard=%CurrentWinX% `, %CurrentWinY%
return

WinSub_WH:
Clipboard=%CurrentWinW% `, %CurrentWinH%
return

WinSub_Text:
Clipboard=%WinText%
return

MouseSub_ScreenXY:
Clipboard=%MousePosScreenX% `, %MousePosScreenY%
return

MouseSub_WindowXY:
Clipboard=%MousePosX% `, %MousePosY%
return

ControlSub_Name:
Clipboard=%ControlName%
return

ControlSub_XY:
Clipboard=%ControlPosX% `, %ControlPosY%
return

ControlSub_WH:
Clipboard=%ControlPosW% `, %ControlPosH%
return

ControlSub_Text:
Clipboard=%ControlText%
return

PixelSub_HEX:
Clipboard=%PixelRGB%
return

PixelBGRSub_HEX:
Clipboard=%PixelBGR%
return

PixelSub_DEC:
Clipboard:=HEXtoDEC(HEX1) " " HEXtoDEC(HEX2) " " HEXtoDEC(HEX3)
return

StatusSub:
StringTrimLeft, StatusText, A_ThisMenuItem, 3
clipboard=%StatusText%
Status:
return

;------------------------------------------------------
-----------------------------------------

;My Function to converts HEX to DEC

HEXtoDEC(HEX)
{
  StringUpper, HEX, HEX
  loop, % StrLen(HEX)
  {
    StringMid, Col, HEX, % (StrLen(HEX)+1)-a_index, 1
    if Col is integer
      DEC1:=Col*16**(a_index-1)
    Else
      DEC1:=(Asc(Col)-55)*16**(a_index-1)
  DEC+=%DEC1%
  }
  return DEC
}










;______________________________________
;#Include winwatcher.txt
1Include_winwatcher:
WINWATCHER:
{
	ToolTip
	KeyWait, SPACE
	KeyWait, CAPSLOCK
	SetCapsLockState, Off
	If winwatcherison = 1
	{
		winwatcherison = 
		Hotkey, CAPSLOCK & SC01B, Off
		Hotkey, CAPSLOCK & -, Off
		Hotkey, CAPSLOCK & ALT, Off
		Hotkey, ^+LButton , Off
		Gui, 5:Destroy
	  DllCall("gdi32.dll\DeleteObject", UInt,h_region )
	  DllCall("gdi32.dll\DeleteObject", UInt,hbm_buffer)
	  DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
	  DllCall("gdi32.dll\DeleteDC", UInt,hdc_buffer)
	  Gosub, RestoreAll
	  WinSet, Redraw
		Return
	}
	else
	{
		Hotkey, CAPSLOCK & SC01B, AddWatch, On
		Hotkey, CAPSLOCK & -, RemoveWatch, On
		Hotkey, CAPSLOCK & ALT, ShowHideGui, On
		Hotkey, ^+LButton , define_region, On
		winwatcherison = 1
	}
	p_w = 200                                    ; thumbnail width
	p_h = 150                                    ; height
	Left    := A_ScreenWidth - p_w               ; initial position
	Height1 := A_ScreenHeight / 1.06
	Height2 := A_ScreenHeight - Height1
	Trans := "FF00FF"                         ; transparency level
	
	
	Gui 5:+AlwaysOnTop -Border +Resize +ToolWindow ; window for the dock
	Gui, 5:Color, FF00FF
	
	ypic =0
	Loop 10,                                     ; prepare 10 thumbs to be clicked
	{
	  Gui, 5:Add, Pic , gRestoreWin x0 y%ypic% w%p_w% h100 vPic%a_index%			; add dock-slots to gui
	  ypic +=100
	}
	
	Gui 5:Show, NoActivate w%p_w% h32 x%Left% y%Height2%, WINWATCHER
	
	WinGet WINWATCHERID, id, WINWATCHER
	WinSet, TransColor, %Trans% 255, WINWATCHER       ; Make Window Transparent for coolness and usability
	
	hdc_frame := DllCall( "GetDC", UInt, WINWATCHERID )
	hdc_buffer := DllCall("gdi32.dll\CreateCompatibleDC", UInt,  hdc_frame)  ; buffer
	hbm_buffer := DllCall("gdi32.dll\CreateCompatibleBitmap", UInt,hdc_frame, Int,A_ScreenWidth, Int,A_ScreenHeight)
	DllCall( "gdi32.dll\SelectObject", UInt,hdc_buffer, UInt,hbm_buffer)
	*
	; comment this line for speed but less quality
	DllCall( "gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4 )  ; Halftone better quality with stretch
	
	SetTimer update_dock, %winwatcherspeed%                  ; x sec update
	Return
}                                 ; flow through 1st call (is efficient, but introduces bugs easily!)

update_dock:
{
  WinGetPos ,,, p_w2, p_h2, WINWATCHER       ; get size of WINWATCHER Window
  p_w2 := p_w2 -8                             ; adjust sizes (margins, borders ..)

  ypos= 0                                    ; offset for each thumbnail
  nr  = 0                                    ; which thumbnail

  WinGet ids, list,,,Program Manager         ; all active windows-tasks (processes)
  Loop %ids% {
     task_id := ids%a_index%                 ; id of this window
     WinGetPos ,,, w, h, ahk_id %task_id%
     WinGetTitle,title,ahk_id %task_id%

                                             ; try to match mediumsize dialog-boxes like alerts/copy or userdefined with #w
     if ( title <> "WINWATCHER" and title <> "" and title <> " "  and (( w > 300 and h < 300 and h > 50 ) or watch_me_%task_id% = 1 ) )
     {              
      
      DllCall("PrintWindow", UInt,task_id, UInt,hdc_buffer, UInt,0)
      
      wx1 := watch_me_x1_%task_id%
      wy1 := watch_me_y1_%task_id%
      ww  := watch_me_w_%task_id%
      wh  := watch_me_h_%task_id%
      nr  += 1
      
      ; ToolTip, %task_id% %current_id% "..." %title% "x" %wx1% "v" %onoff%

       if  wx1 <>
       {
        h1 := wh * ( p_w2 / ww )                  ; autosize (seems not exaclty right?)
      
        DllCall("gdi32.dll\StretchBlt", UInt,hdc_frame, Int,0, Int,ypos, Int,p_w2, Int,h1
              , UInt,hdc_buffer, Int, wx1, Int,wy1, Int,ww, Int,wh ,UInt,0xCC0020) ; SRCCOPY
       }
       else
       {
         h1 := h * ( p_w2 / w )                  ; autosize (seems not exaclty right?)
         DllCall("gdi32.dll\StretchBlt", UInt,hdc_frame, Int,0, Int,ypos, Int,p_w2, Int,h1
              , UInt,hdc_buffer, Int,0, Int,0, Int,w, Int,h ,UInt,0xCC0020) ; SRCCOPY
       }

       watch_me_id_%nr% := task_id    ; store src-window id for later restore
       watch_me_title_%nr% := title

       GuiControl, Move, Pic%nr%, X0 Y%ypos% W%p_w2% H%h1%
       
       ypos += h1                          ; move down to next thumbnail-position
    }
  }
  WinMove WINWATCHER,,,,,ypos +32         ; resize to make pseudo-transparent
Return
}

AddWatch:
		KeyWait, CAPSLOCK
		SetCapsLockState, Off
    WinGet current_id , id , A         ; get ahk_id of foreground window
   
    watch_me_%current_id% = 1
Return

RemoveWatch:
   	KeyWait, CAPSLOCK
		SetCapsLockState, Off
    WinGet current_id , id , A         ; get ahk_id of foreground window

    watch_me_%current_id% =
    watch_me_x1_%current_id% = 
Return

RestoreWin: 
			Gui, 5:Show, NA
    	StringReplace, pos , A_GuiControl, Pic
    	xid    := watch_me_id_%pos%
    	WinActivate, ahk_id %xid%
    	Gosub, ScreenBottom
Return
 


define_region:
   CoordMode, Mouse, Relative                ; relative to window not screen
   MouseGetPos, start_x, start_y             ; start position of mouse
   ToolTip, %A_Space%, start_x, start_y      ; pseudo layer
   WinSet, Transparent, 150, ahk_class tooltips_class32 ; draw "layer" as feedback
   SetTimer mousemark, 50                        ; check every 50ms for mouseup
Return

mousemark:
{
   MouseGetPos, current_x, current_y
   WinMove, ahk_class tooltips_class32, , , , % current_x - start_x, % current_y - start_y
   If GetKeyState("LButton", "P")
      Return
   SetTimer mousemark, OFF
   ToolTip
   MouseGetPos, end_x, end_y
   ;TrayTip, ,you selected %start_x% %start_y% %end_x% %end_y%, , 5

   width := end_x - start_x
   height := end_y - start_y

   WinGet current_id , id , A         ; get ahk_id of foreground window

   ;WinGetTitle,title, ahk_id %current_id%
   ;tooltip, "current" %current_id% %title%


   watch_me_x1_%current_id% := start_x
   watch_me_x2_%current_id% := end_x
   watch_me_y1_%current_id% := start_y
   watch_me_y2_%current_id% := end_y
   watch_me_w_%current_id%  := width
   watch_me_h_%current_id%  := height

   ;WinGetPos ,src_x, src_y, src_w, src_h, A
   ;watch_me_src_y_%current_id% := src_y
   ;watch_me_src_x_%current_id% := src_x
		
		Gosub, ScreenBottom         ; make it minimized
		return
}

ScreenBottom:
{
   ; when clicked then use current window
   IfWinActive, WINWATCHER
   	WinActivate
   WinGet current_id , id , A         ; get ahk_id of foreground window
	
   minimized := minimized_state_%current_id%
   screenborder_x := 
   screenborder_y := A_ScreenHeight - 24
   if minimized = 
   {
     minimized_state_%current_id% := 1
     WinGetPos ,wx,wy,ww,wh, ahk_id %current_id%
     minmized_x_%current_id% := wx
     minmized_y_%current_id% := wy

     WinMove , ahk_id %current_id%,, screenborder_x,screenborder_y       ; move to screenborder (keep x-pos)
   }
   else
   {
      x := minmized_x_%current_id% 
      y := minmized_y_%current_id% 

      WinMove , ahk_id %current_id%,, x,y       ; restore
      minimized_state_%current_id% :=
   }
return 
}

ShowHideGui:
  IfWinExist, WINWATCHER ;  if ( DllCall( "IsWindowVisible", "uint", LiveWindowsID ) )
      Gui, 5:Hide
   else
      Gui, 5:Show 
Return 

RestoreAll:
   WinGet, ids, list,,, Program Manager
	Loop, %ids%
	{
		StringTrimRight, id, ids%a_index%, 0				; find the id of this window
	    if minimized_state_%id% = 1
        {
          WinActivate, ahk_id %id%
          Gosub, ScreenBottom
        }    
	}
Return

5GuiClose:
Hotkey, CAPSLOCK & SC01B, Off
Hotkey, CAPSLOCK & -, Off
Hotkey, CAPSLOCK & ALT, Off
Hotkey, ^+LButton, Off
Gui, 5:Destroy
handle_exit:
   DllCall("gdi32.dll\DeleteObject", UInt,h_region )
   DllCall("gdi32.dll\DeleteObject", UInt,hbm_buffer)
   DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
   DllCall("gdi32.dll\DeleteDC", UInt,hdc_buffer)
   Gosub, RestoreAll
Return






;____________________________________________
;#Include import.txt
1Include_import:
Import:
{
	IfWinExist, %SCRIPTNAME_VAR% IMPORT
	{
		WinActivate, %SCRIPTNAME_VAR% IMPORT
		Return
	}
	Gui, 1:Destroy
	FileSelectFile, fileparams
	Gui, Submit, NoHide
	Gui, 7:Add, ListView, r19 w660 Count500 AltSubmit +ReadOnly Grid Multi gImportchange vListimport, MACRO KEYWORD|NAME/AUTOSTART/CAPSLOCK/HOTEKEY|MACRO COMMANDS|PARAMETERS
	Gui, 7:Default
	Loop, Read, %fileparams%
	{
		Loop 4
		importvalue%A_Index% =
		importvaluefirst =
		importvalue := A_LoopReadLine
		StringLeft, importvaluefirst, importvalue, 1
		If importvaluefirst = [
		{
			continue
		}
		Stringsplit, importvaluecheck, importvalue, `=, %A_Space%
		importvaluecheck = %importvaluecheck%
		If (importvaluecheck1 = "F93DHH98E08776AC" or importvalue = "" or importvaluecheck1 = "defaultprofile")
			continue
		StringReplace, importvalue, importvalue, `=, `°,
		Stringsplit, importvalue, importvalue, `°%programseparator%, %A_Space%
		importend := LV_Add("",importvalue1, importvalue2,importvalue3,importvalue4)
		If importend = 0
		break
	}
	Loop 4
		importvalue%A_Index% =
	importvaluefirst =
	Gui, 7:Add, Button, xs Default gImportkey, IMPORT
	Gui, 7:Add, Button, x+0 g7GuiClose, EXIT
	Gui, 7:Add, Text, xs, SHOR&TKEYS        :
	Gui, 7:Add, Edit, x+1 -WantTab -WantReturn w120,
	Gui, 7:Add, Text, xs, NA&ME                    :
	Gui, 7:Add, Edit, x+1 -WantTab -WantReturn w550,
	Gui, 7:Add, Text, xs, PA&RAMS                :
	Gui, 7:Add, Edit, x+1 -WantTab -WantReturn w550,
	Gui, 7:Add, Text, xs, MACR&O                  :
	Gui, 7:Add, Edit, x+1 -WantTab r22 w550,
	Gui, 7:Show
	Gui, 7:Submit, Nohide
	WinSetTitle, %SCRIPTNAME_VAR%,, %SCRIPTNAME_VAR% IMPORT
	Return
}

7GuiClose:
{
	Gui, 7:Destroy
	Gui, 1:Default
	GoSub, RESTARTINI
	GoSub, Macrokeys
	Exit
}

7GuiEscape:
{
	Gui, 7:Destroy
	Gui, 1:Default
	GoSub, RESTARTINI
	GoSub, Macrokeys
	Exit
}



Importchange:
{
	Gui, 7:Submit, NoHide
	If (A_GuiEvent = "Normal" or A_GuiEvent = "I")
	{
		If A_GuiEvent = I
		{
			IfNotInString, Errorlevel, S
				Return
		}
			If A_EventInfo > 0
			{
				GuiControl, , Edit1,
				GuiControl, , Edit2,
				GuiControl, , Edit3,
				GuiControl, , Edit4, 
				;MsgBox % A_EventInfo
				LV_GetText(importvaluechangekey, A_EventInfo, 1)
				selectedrow = %A_EventInfo%
				selectedkey  := importvaluechangekey
				LV_GetText(importvaluenew, A_EventInfo, 3)
				LV_GetText(importvaluenamenew, A_EventInfo, 2)
				LV_GetText(importvalueparam, A_EventInfo, 4)
				StringLen, importvaluenewlength, importvaluenew
				If importvaluenewlength = 8190
				{
					MsgBox, 0, MACRO TOO LONG, CANNOT IMPORT MACRO AS IT IS TOO LONG
					Return
				}
				StringReplace, importvaluenew, importvaluenew, %macroseparator%, `n, A
				GuiControl, , Edit1, %importvaluechangekey%
				GuiControl, , Edit2, %importvaluenamenew%
				GuiControl, , Edit3, %importvalueparam%
				GuiControl, , Edit4, %importvaluenew%
			}
	}
	
	Return
}

ImportKey:
{
	Gui, 7:Submit, NoHide
	GuiControlGet, importvaluechangekey, , Edit1
	If importvaluechangekey =
	{
		Return
	}
	GuiControlGet, importvaluenamenew, , Edit2
	GuiControlGet, importvalueparam, , Edit3
	GuiControlGet, importvaluenew, , Edit4
	StringReplace, importvaluenew, importvaluenew, `n, %macroseparator%, A
	importnewvalue = %importvaluenamenew%%programseparator%%importvaluenew%%programseparator%%importvalueparam%
	If importnewvalue =
	{
		Return
	}
	StringLeft, importnewvaluename, importnewvalue, InStr(importnewvalue, programseparator)
	MsgBox, 4, IMPORT MACRO, DO YOU WANT TO IMPORT MACRO?`n`nPROFILE: `t%ActiveTab%`nKEYWORD: `t%importvaluechangekey%`nNAME: `t`t%importnewvaluename%
	IfMsgBox Yes
	{
		IfNotEqual, %importvaluechangekey%2,
		{
			MsgBox, 4, %SCRIPTNAME_VAR% OVERWRITE, MACRO ALREADY EXISTS`nDO YOU WANT TO OVERWRITE?
			IfMsgBox No
			{
				MsgBox, 0, %SCRIPTNAME_VAR% IMPORT, IMPORT WAS CANCELED, 5
				Return
			}
		}
		IniWrite, %importnewvalue%, %config%, %ActiveTab%, %importvaluechangekey%
	}
	Return
}





;__________________________________
;#Include recorder.txt
1Include_recorder:
DeleteLastRecord:
{
	StringTrimRight, recordoutput, recordoutput, 1
	;ToolTip, %recordoutput%, 0, 30
	Return
}

Recordmouse:
{
	MouseGetPos, moverecordoutputx, moverecordoutputy, recordoutputwin, recordoutputcontrol
	KeyWait, RButton
	KeyWait, LButton
	MouseGetPos, mrecordoutputx, mrecordoutputy, recordoutputwin, recordoutputcontrol
	If (mrecordoutputx = moverecordoutputx and mrecordoutputy = moverecordoutputy)
	{
		WinGetActiveTitle, newwindow
		WinGetClass, newwinclass, A
		If (newwinclass != currentwinclass or newwindow != currentwindow)
		{
			currentwinclass := newwinclass
			currentwindow := newwindow
			If (currentwinclass != "" and currentwindow != "")
				recordoutput .= macroseparator . "WinActivate, " . newwindow . " ahk_Class " . newwinclass . macroseparator . "WinWaitActive, " . newwindow . " ahk_Class " . newwinclass . macroseparator
		}
		IfInString, recordoutputcontrol, Button
		{
			If A_ThisHotkey = ~RButton Up
					recordoutput .= macroseparator . "ControlClick, " . recordoutputcontrol . ", " . currentwindow . ",, right, 2" . macroseparator
			else
					recordoutput .= macroseparator . "ControlClick, " . recordoutputcontrol . ", " . currentwindow . ",, left, 2" . macroseparator
		}
		else
		{
			If A_ThisHotkey = ~RButton Up
					recordoutput .= macroseparator . "Click, right, " . mrecordoutputx . ", " . mrecordoutputy . macroseparator
			else
					recordoutput .= macroseparator . "Click, " . mrecordoutputx . ", " . mrecordoutputy . macroseparator
		}
	}
	else
	{
		WinGetActiveTitle, newwindow
		WinGetClass, newwinclass, A
		If (newwinclass != currentwinclass or newwindow != currentwindow)
		{
			currentwinclass := newwinclass
			currentwindow := newwindow
			If RegExMatch(recordoutput, "!\{TAB}$|!\{TAB.}$|!\{TAB..}$|!\{TAB...}$")   ;SubStr(recordoutput, 0, 6) = "!{TAB}"
			{
				StringLeft, recordoutput, recordoutput, RegExMatch(recordoutput, "!\{TAB????}$") ;StringTrimRight, recordoutput, recordoutput, 6
				If (currentwinclass != "" and currentwindow != "")
					recordoutput .= macroseparator . "WinActivate, " . newwindow . " ahk_Class " . newwinclass . macroseparator
			}
		}
		If A_ThisHotkey = ~RButton UP
			recordoutput .= macroseparator . "MouseClickDrag, right, " . moverecordoutputx . ", " . moverecordoutputy ", " . mrecordoutputx . ", " . mrecordoutputy . macroseparator
		else
			recordoutput .= macroseparator . "MouseClickDrag, left, " . moverecordoutputx . ", " . moverecordoutputy ", " . mrecordoutputx . ", " . mrecordoutputy . macroseparator
	}
	;ToolTip, %recordoutput%, 0, 30
	moverecordoutputx =
	moverecordoutputy =
	mrecordoutputx =
	mrecordoutputy =
	Return
}

RecordRemoveToolTip:
	ToolTip
Return

RecordPause:
	recordsleep++
	;MsgBox %  recordoutput RegExMatch(recordoutput, "\Sleep, .000\$")
	If RegExMatch(recordoutput, "\Sleep, .000$|\Sleep, ..000$|\Sleep, ...000$")
	{
		StringLeft, recordoutput, recordoutput, RegExMatch(recordoutput, "\Sleep, .000$|\Sleep, ..000$|\Sleep, ...000$")-1
		recordoutput .= macroseparator . "Sleep, " . recordsleep . "000" . macroseparator
	}
	else
	{
		recordsleep = 0
		recordoutput .= macroseparator . "Sleep, 1000" . macroseparator
	}
Return

Record:
WinGetActiveTitle, currentwindow
WinGetClass, currentwinclass, A
recordstartwindow := "WinActivate, " . currentwindow . " ahk_Class" . currentwinclass . macroseparator . "WinWaitActive, " . currentwindow . " ahk_Class" . currentwinclass . macroseparator
recordoutput .= "WinActivate, " . currentwindow . " ahk_Class" . currentwinclass . macroseparator . "WinWaitActive, " . currentwindow . " ahk_Class" . currentwinclass . macroseparator
Hotkey, ~LButton, ON
Hotkey, ~RButton, ON
Hotkey, CAPSLOCK & BACKSPACE, DeleteLastRecord
Hotkey, CAPSLOCK & SPACE, RecordPause
Hotkey, CAPSLOCK & ENTER, RecordRemoveToolTip
Hotkey, ~Pause, Off
;Hotkey, CAPSLOCK & ENTER, RecordAddCommand
ToolTip, RECORDING... - PRESS PAUSE TO FINISH - CAPSLOCK & SPACE TO ADD [SLEEP`, 1000] - CAPSLOCK & ENTER TO REMOVE THIS TOOLTIP, 200, 20
Loop
{
	;ToolTip, %recordoutput%, 0, 30
	Input, recordout, L1 V B, {Scrolllock}{Numlock}{AppsKey}{+}{^}{#}{!}{LALT}{RALT}{LWIN}{CAPSLOCK}{PAUSE}{BREAK}{PRINTSCREEN}{TAB}{BS}{ENTER}{LEFT}{RIGHT}{UP}{DOWN}{DEL}{INS}{ESC}{HOME}{END}{PGUP}{PGDN}{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadEnter}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{F13}{F14}{F15}{F16}{F17}{F18}{F19}{F20}{F21}{F22}{F23}{F24}abcdefghijklmnopqrstuvwxyz0123456789{SPACE}
	If Errorlevel = Endkey:CapsLock
	{
		KeyWait, Capslock
		If GetKeyState("Capslock", "T") = 0
			recordoutput .= "{Shift up}"
		else
			recordoutput .= "{Shift down}"
	}
	else if Errorlevel = Endkey:Scrolllock
	{
		KeyWait, Scrolllock
		If GetKeyState("Scrolllock", "T") = 0
			recordoutput .= macroseparator . "SetScrollLockState, Off" . macroseparator
		else
			recordoutput .= macroseparator . "SetScrollLockState, On" . macroseparator
	}
	else if Errorlevel = Endkey:Numlock
	{
		KeyWait, Numlock
		If GetKeyState("Numlock", "T") = 0
			recordoutput .= macroseparator . "SetNumLockState, Off" . macroseparator
		else
			recordoutput .= macroseparator . "SetNumLockState, On" . macroseparator
	}
	If Errorlevel = Endkey:Pause
	{
		counted_key = 1
		recordendkey =
		break
	}
	else
		Recorderrorkey = %Errorlevel%
	WinGetActiveTitle, newwindow
	WinGetClass, newwinclass, A
	If (newwinclass != currentwinclass or newwindow != currentwindow)
	{
		currentwinclass := newwinclass
		currentwindow := newwindow
		If RegExMatch(recordoutput, "!\{TAB}$|!\{TAB.}$|!\{TAB..}$|!\{TAB...}$")   ;SubStr(recordoutput, 0, 6) = "!{TAB}"
		{
			StringLeft, recordoutput, recordoutput, RegExMatch(recordoutput, "!\{TAB}$|!\{TAB.}$|!\{TAB..}$|!\{TAB...}$")-1 ;StringTrimRight, recordoutput, recordoutput, 6
			If (currentwinclass != "" and currentwindow != "")
				recordoutput .= macroseparator . "WinActivate, " . newwindow . " ahk_Class " . newwinclass . macroseparator
		}
		If (currentwinclass != "" and currentwindow != "")
			recordoutput .= macroseparator . "WinWaitActive, " . newwindow . " ahk_Class " . newwinclass . macroseparator
	}
	IfInString, Recorderrorkey, EndKey:
	{
		GetKeyState, shiftisstilldown, SHIFT, P
		GetKeyState, ctrlisstilldown, CTRL, P
		GetKeyState, altisstilldown, ALT, P
		GetKeyState, winisstilldown, LWIN, P
		If (recordendkey = SubStr(Recorderrorkey, 8) and shiftisstilldown = shiftisdown and winisstilldown = winisdown  and ctrlisstilldown = ctrlisdown and altisstilldown = altisdown)
		{
			counted_key++
			If counted_key = 2
			{
				If SubStr(recordoutput, 0) = "}"
				{
					StringTrimRight, recordoutput, recordoutput, 1
					recordoutput .= " " . counted_key . "}"
					continue
				}
			}
			else
			{
				If SubStr(recordoutput, 0) = "}"
				{
					StringLeft, recordoutput, recordoutput, RegExMatch(recordoutput, " .}$| ..}$| ...}$| ....}$| .....}$")-1
					recordoutput .= " " . counted_key . "}"
					continue
				}
			}
		}
		else
			counted_key = 1
		recordendkey := SubStr(Recorderrorkey, 8)
		GetKeyState, shiftisdown, SHIFT, P
		GetKeyState, ctrlisdown, CTRL, P
		GetKeyState, altisdown, ALT, P
		GetKeyState, winisdown, LWIN, P
		If (shiftisdown = "D" and SubStr(recordoutput, 0) != "+")
		{
				recordoutput .= "+"
		}
		If (ctrlisdown = "D" and SubStr(recordoutput, 0) != "^")
		{
				recordoutput .= "^"
		}
		If (altisdown = "D" and SubStr(recordoutput, 0) != "!")
		{
				recordoutput .= "!"
		}
		If (winisdown = "D" and SubStr(recordoutput, 0) != "#")
		{
				recordoutput .= "#"
		}
		Loop %recordmodshort0%
		{
			If recordmodkeys%A_Index% = %recordendkey%
			{
				recordoutput .= recordmodshort%A_Index%
				continue
			}
		}
		continue
	}
	counted_key = 1
	recordendkey =
	recordoutput .= recordout
}
StringReplace, recordoutput, recordoutput, %macroseparator%%macroseparator%, %macroseparator%,A
StringReplace, recordoutput, recordoutput, ##, #, A
If (recordoutput != recordstartwindow)
	setupparamv .= recordoutput
VarSetCapacity(recordoutput, 0)
moverecordoutputx := ""
moverecordoutputy := ""
Hotkey, ~LButton, Off
Hotkey, ~RButton, Off
Hotkey, CAPSLOCK & BACKSPACE, Speedhotkey
Hotkey, CAPSLOCK & SPACE, WinWatcher
Hotkey, CAPSLOCK & ENTER, SPEEDHOTKEY
Hotkey, ~Pause, On
Return
