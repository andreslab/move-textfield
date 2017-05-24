//
//  ViewController.swift
//  moveTextView
//
//  Created by Jaime_Andrade on 5/24/17.
//  Copyright © 2017 Jaime Andrade. All rights reserved.
//

import UIKit
import Foundation
import CoreFoundation


class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var textFieldTop: UITextField!
    
    var keyboardHeight: CGFloat!
    var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [textFieldTop, textFieldBottom]
        
        var scrollGestureRecognizer: UITapGestureRecognizer!
        scrollGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(scrollGestureRecognizer)
        
        
        var center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    

    
    
    
    func keyboardWillShow(notification: NSNotification){
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        print( "el teclado se va a mostrar y tiene una altura de \(keyboardSize.height)")
        keyboardHeight = keyboardSize.height
        
        setScrollViewPosition()
    }
    func keyboardWillHide(notification: NSNotification){
        print("El teclado se va a ocultar")
        bottomConstrain.constant = 40
        self.view.layoutIfNeeded()
    }

    
    //función que modificará la posición del textField
    func setScrollViewPosition(){
        //modificamos el valor de la constante del constrain inferior, le damos la altura del teclado más 20 del marge.
        bottomConstrain.constant = keyboardHeight + 20
        self.view.layoutIfNeeded() //permite la modificacion del constrain
        
        //calculaos la altura de la pantalla
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight: CGFloat = screenSize.height
        
        //recorremos el array de textfields en busca de quien tiene el foco
        for textField in textFields{
            if textField.isFirstResponder{
                //guardamos la posicion "y" del UITextField
                let yPositionField = textField.frame.origin.y
                //guardamos la altura de UITextField
                let heightField = textField.frame.size.height
                //calculamos la Y maxima del UITextField
                let yPositionMaxField = yPositionField + heightField
                //calculamos la Y maxima del view que no queda ocultar por el teclado
                let Ymax = screenHeight - keyboardHeight
                //comprobamos si nuestra Y maxima del UITextField es superior por el teclado
                if Ymax < yPositionMaxField {
                    //comprobamos si la "Ymax" del UITextField es mas grande que el tamaño de la pantalla
                    if yPositionMaxField > screenHeight {
                        let diff = yPositionMaxField - screenHeight
                        print("El UITextField se sale por debajo \(diff) unidades")
                        // Hay que añadir la distancia a la que está por debajo el UITextField ya que se sale del screen height
                        //scrollView.setContentOffset(CGPointMake(0, self.keyboardHeight + diff), animated: true)
                        scrollView.setContentOffset(CGPoint.init(x: 0, y: self.keyboardHeight + diff), animated: true)
                    }else{
                        // El UITextField queda oculto por el teclado, entonces movemos el Scroll View
                        scrollView.setContentOffset(CGPoint.init(x: 0, y:self.keyboardHeight - 20), animated: true)
                        
                    }
                }else {
                    print("NO MUEVO EL SCROLL")
                }
            }
        }
    }
    
    
    
    func hideKeyboard(){
        view.endEditing(true)
    }

}

