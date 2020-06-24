Attribute VB_Name = "提取我的项目"
Sub extract()

     'workbook 数组
    Dim wkb(4) As Workbook
    Dim dates As String         '日期
    
    '"20200608"
    dates = InputBox("请输入目标日期：")
    

        
    Set wkb(1) = Workbooks.Open("C:\Users\Administrator\Desktop\水样品编号一览表(更新到6月).xlsx")
    Set wkb(2) = Workbooks.Open("C:\Users\Administrator\Desktop\vba\氨氮.xlsx")
    Set wkb(3) = Workbooks.Open("C:\Users\Administrator\Desktop\vba\总氮.xlsx")
    Set wkb(4) = Workbooks.Open("C:\Users\Administrator\Desktop\vba\氟化物.xlsx")
    
    '获取目标信息并写入目标xlsx
    Call get_info(wkb, dates)
    
     
    'wkb.Close
    
    
End Sub

'获取目标项目编号、厂家，并写入目标xlsx

Private Sub get_info(ByRef wkb() As Workbook, dates As String)
    Dim adr As Integer          '氨氮有效行数
    Dim zdr As Integer          '总氮有效行数
    Dim fr As Integer           '氟化物有效行数
    Dim rows As Integer         '水样表有效行数
    Dim month As Integer
    Dim asb As Single          '吸光度
    Dim dil As Integer          '稀释度
    
    '获得月份
    month = Right(Left(dates, 6), 1)
    'MsgBox (month)
    
    '获得水样表有效行数
    rows = wkb(1).Sheets(month & "月").UsedRange.rows.Count
    'MsgBox ("水样：" & rows)
    adr = get_rows(wkb(2).Sheets(month & "月"))
    'MsgBox ("ad：" & adr)
    zdr = get_rows(wkb(3).Sheets(month & "月")) + 1
    'MsgBox ("zd：" & zdr)
    fr = get_rows(wkb(4).Sheets("2020")) + 1
    'MsgBox ("fhw：" & fr)
    
    'Exit Sub
        
    
    ' 找到目标日期
    For i = 2 To rows
        If InStr(1, wkb(1).Sheets(month & "月").Cells(i, 2).Value, dates) > 0 Then
            Exit For
        End If
    Next i
    
    If i >= rows Then
        MsgBox ("没找到该日期的记录")
    Else
         ' 提取目标项目的编号、厂家
        Do While InStr(1, wkb(1).Sheets(month & "月").Cells(i, 2).Value, dates) > 0
             '氨氮
             If InStr(1, wkb(1).Sheets(month & "月").Cells(i, 4).Value, "氨氮") > 0 Then
                wkb(2).Sheets(month & "月").Cells(adr, 3).Value = wkb(1).Sheets(month & "月").Cells(i, 2).Value        '编号
                wkb(2).Sheets(month & "月").Cells(adr, 4).Value = wkb(1).Sheets(month & "月").Cells(i, 3).Value        '厂家
                
                wkb(2).Sheets(month & "月").Cells(adr, 1).Value = wkb(1).Sheets(month & "月").Cells(i, 7).Value        '频次 eg.月度
                wkb(2).Sheets(month & "月").Cells(adr, 1).Interior.ColorIndex = 3                                      '背景色为 红
                wkb(2).Sheets(month & "月").Cells(adr, 1).Font.ColorIndex = 2                                          '字体 白
                
                If month - 1 > 0 Then
                    Call get_asb_dil(wkb(2).Sheets((month - 1) & "月"), wkb(2).Sheets(month & "月").Cells(adr, 4).Value, asb, dil, 1)      '吸光度、稀释度
                    wkb(2).Sheets(month & "月").Cells(adr, 6).Value = asb
                    wkb(2).Sheets(month & "月").Cells(adr, 7).Value = dil
                End If
                
                adr = adr + 1
             End If
                
             '总氮
             If InStr(1, wkb(1).Sheets(month & "月").Cells(i, 4).Value, "总氮") > 0 Then
                wkb(3).Sheets(month & "月").Cells(zdr, 3).Value = wkb(1).Sheets(month & "月").Cells(i, 2).Value        '编号
                wkb(3).Sheets(month & "月").Cells(zdr, 4).Value = wkb(1).Sheets(month & "月").Cells(i, 3).Value        '厂家
                
                wkb(3).Sheets(month & "月").Cells(zdr, 1).Value = wkb(1).Sheets(month & "月").Cells(i, 7).Value        '频次 eg.月度
                wkb(3).Sheets(month & "月").Cells(zdr, 1).Interior.ColorIndex = 3                                      '背景色为 红
                wkb(3).Sheets(month & "月").Cells(zdr, 1).Font.ColorIndex = 2                                          '字体 白
                
                If month - 1 > 0 Then
                    Call get_asb_dil(wkb(3).Sheets((month - 1) & "月"), wkb(3).Sheets(month & "月").Cells(zdr, 4).Value, asb, dil, 2)      '吸光度、稀释度
                    wkb(3).Sheets(month & "月").Cells(zdr, 6).Value = asb
                    wkb(3).Sheets(month & "月").Cells(zdr, 7).Value = dil
                End If
                
                zdr = zdr + 1
             End If
             
             '氟化物
             If InStr(1, wkb(1).Sheets(month & "月").Cells(i, 4).Value, "氟化物") > 0 Then
                wkb(4).Sheets("2020").Cells(fr, 3).Value = wkb(1).Sheets(month & "月").Cells(i, 2).Value        '编号
                wkb(4).Sheets("2020").Cells(fr, 4).Value = wkb(1).Sheets(month & "月").Cells(i, 3).Value        '厂家
                
                wkb(4).Sheets("2020").Cells(fr, 1).Value = wkb(1).Sheets(month & "月").Cells(i, 7).Value        '频次 eg.月度
                wkb(4).Sheets("2020").Cells(fr, 1).Interior.ColorIndex = 3                                      '背景色为 红
                wkb(4).Sheets("2020").Cells(fr, 1).Font.ColorIndex = 2                                          '字体 白
                
                fr = fr + 1
             End If
                           
             i = i + 1
         Loop
    End If
       

End Sub

'获得一个sheet的有效行数
Private Function get_rows(sht As Worksheet) As Integer
    Dim r As Integer
    
    r = 1
    Do While sht.Cells(r, 1).Interior.ColorIndex > 2
        r = r + 1
    Loop
    
    get_rows = r - 1
    
End Function

'获得吸光度、稀释度
'param: 前一个月sheet对象，厂家名，吸光度，稀释度，项目（1：ad, 2：zd）
'rets : －1 for error
Private Function get_asb_dil(sht As Worksheet, mf As String, ByRef asb As Single, ByRef dilution As Integer, proj As Integer)
    Dim r As Integer
    
    r = get_rows(sht)
    For i = 1 To r
        If StrComp(sht.Cells(i, 4).Value, mf) = 0 Then
            If proj = 1 Then
                asb = sht.Cells(i, 8).Value
                dilution = sht.Cells(i, 11).Value
            ElseIf proj = 2 Then
                asb = sht.Cells(i, 14).Value
                dilution = sht.Cells(i, 8).Value
            End If
            
            Exit For
        End If
    Next i
    
    If i >= r Then
        'MsgBox ("没有该厂家：" & mf)
        asb = -1
        dilution = -1
    End If
End Function



























