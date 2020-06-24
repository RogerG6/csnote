Attribute VB_Name = "自动计算"

' 氨氮，总氮，氨的自动计算
Sub auto_cal()
    Dim cr As Integer           '当前行
    Dim head As Integer         '开始行
    Dim tail As Integer         '结束行
    Dim fn   As String          'filename
    
    fn = ActiveWorkbook.Name
    
    head = Selection.row()
    tail = head + Selection.rows.Count - 1
    
    If InStr(1, fn, "氨氮") > 0 Then
        '遍历
        For cr = head To tail
            Call ad_auto_cal(cr)
        Next cr
    ElseIf InStr(1, fn, "总氮") > 0 Then
        '遍历
        For cr = head To tail
            Call zd_auto_cal(cr)
        Next cr
    ElseIf InStr(1, fn, "氨") > 0 Then
        '遍历
        For cr = head To tail
            Call a_auto_cal(cr)
        Next cr
    End If
        
    

End Sub


' 氨氮自动计算
Private Sub ad_auto_cal(r As Integer)
    
    'r = Selection.row()

    '净吸光度
    Cells(r, 10).Value = "= H" & r & "- I" & r
    
    '取样体积
    Cells(r, 12).Value = "=50/K" & r
    
    'b, a
    Cells(r, 13).Value = Cells(r - 1, 13).Value
    Cells(r, 14).Value = Cells(r - 1, 14).Value
    
    '曲线值
    Cells(r, 15).Value = "=(J" & r & "-M" & r & ") / N" & r
    
    '浓度
    Cells(r, 16).Value = "=O" & r & "/L" & r
    
End Sub



' 总氮自动计算
Private Sub zd_auto_cal(r As Integer)
    
    'r = Selection.row()

    '空白净吸光度 M=K-2L
    Cells(r, 13).Value = "=K" & r & "-2*L" & r
    
    
    ' 样品净吸光度 P=N-2O
    Cells(r, 16).Value = "=N" & r & "-2*O" & r
    
    ' 扣除空白吸光度 Q=P-M
    Cells(r, 17).Value = "=P" & r & "-M" & r
    
    'b, a
    Cells(r, 9).Value = Cells(r - 1, 9).Value
    Cells(r, 10).Value = Cells(r - 1, 10).Value
    
    '曲线值 R=(Q-I)/J
    Cells(r, 18).Value = "=(Q" & r & "-I" & r & ") / J" & r
    
    '浓度 S=R/10*H
    Cells(r, 19).Value = "=R" & r & "/10*H" & r
    
End Sub

' 氨自动计算
Private Sub a_auto_cal(r As Integer)
    
    'r = Selection.row()

    '净吸光度
    Cells(r, 9).Value = "= G" & r & "- H" & r
    
    '取样体积
    'Cells(r, 12).Value = "=50/K" & r
    
    'b, a
    Cells(r, 10).FormulaR1C1 = "=R[-1]C"
    Cells(r, 11).FormulaR1C1 = "=R[-1]C"
    
    '曲线值 O=(I-K)/J
    Cells(r, 15).Value = "=(I" & r & "-K" & r & ") / J" & r
    
    '浓度 =O*L/N/M
    Cells(r, 16).Value = "=O" & r & "*L" & r & "/N" & r & "/M" & r
    
End Sub






















