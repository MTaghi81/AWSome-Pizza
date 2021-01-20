#! /bin/bash

## Team name : AWEsome Quartet
##   Limit input error upto 3 times



### Take customer’s name and phone number
# Variable : CustomerName, PhoneNo

function Name_Phone () {
   echo ""
   echo "    <<   Enter your name and phone number please  >>  "
   echo ""
   read -p "        Your name   :    " CustomerName
   read -p "        Phone No.   :    " PhoneNo
   echo ""
   echo ""
   read -p "   Your name is   \"$CustomerName\"  and  Phone No. is \"$PhoneNo\". Correct?  Y or N  ===> " C_Info
  # return $CustomerName $PhoneNo
}
#--------------End of Function--------------------

# Enter client's name and phone number
function Client_Info () {

Name_Phone         #function : enter name and phone number

while [ "$C_Info" != "Y" ] && [ "$C_Info" != "y" ]    # when Name or Phone # is not correct
do
   if [ "$C_Info" = "N" ] || [ "$C_Info" = "n" ]; then    # when Name or Phone # is not correct
       echo ""
       Name_Phone
   else                                                   # when input is not valid -> ask to enter Y or N
       echo ""
       read -p "  Please enter Y or N  ===> " C_Info
   fi
done
}
#--------------End of Function--------------------


function Check_Entered_Number () {   # $1 : option number  $2 : Variable name -> Entered number
local Var_Menu=$2

while ((Var_Menu < 1)) || ((Var_Menu >$1))
do
          echo ""
          read -p "  Please enter the number [1 - $1]    ===> "  Var_Menu
          echo ""
done
return $Var_Menu

}
#--------------End of Function--------------------


# Enter delivery address

function Delivery_Address () {
         echo ""
         read -p " *     Please enter Delivery Address    :     "  D_addr  # Delivery Address
         echo ""
         read -p " Delivery address $D_addr. Correct?    Y or N  ===>  "  C_addr

         while [ "$C_addr" != "Y" ] && [ "$C_addr" != "y" ]    
         do 
              if [ "$C_addr" = "N" ] || [ "$C_addr" = "n" ]; then    # Type of order input is not correct
                   echo ""
                   read -p "    Please enter correct delivery Address    :   "  D_addr   # Deliverty address
                   echo ""
                   read -p "  Is Delivery address $D_addr?    Y or N  ===>  "  C_addr    # IS entered address correct?
              else
                 echo "" 
                 read -p "  Please enter Y or N  ===>  "  C_addr     # Y or N input is not correct
              fi
         done 
}

# Select type of order : Carry out or Delivery
function Type_Order () {

clear   
echo ""   
echo -e "             "`echo -e '\033[0;33m'`"\e[3m\e[1m<<   Select Type of Order   >>\e[0m`tput init`"       

echo ""
read -p "      1: Carry Out       2: Delivery    ===>  " T_order    #T_order : 1 -> Carrry out 2 -> Delivery
echo ""

Check_Entered_Number 2 $T_order
T_order=$?


case $T_order in
      1) echo "------------------------------------------------------------------------"
         echo "                                                                        "
         echo "        Your order will be ready to pick up in 20 minutes               " 
         echo "                                                                        "
         echo "                Would you like to order ?                               "
         echo ""
         echo ""
         read -p " 1 YES, start order  2. No, change to Delivery  3. Stop and exit   ==>  " S_order
         
         Check_Entered_Number 3 $S_order
         S_order=$?
         
         if (( S_order == 2 )) ; then
              echo ""
              echo ""
              echo "  Your order will be delivered in 45 minutes w/ $3.99 delivery fee      " 
              echo "                                                                        "
              echo "  Change to delivery ?"
              echo ""
              echo ""
              read -p " 1 YES, change to delivery  2. No, stay with Carry Out   ==>  " S_order
         
              Check_Entered_Number 2 $S_order
              S_order=$?         
              if (( S_order== 1 )) ; then
                   Delivery_Address
              fi
         elif (( S_order == 3 )) ; then 
              echo ""
              echo ""
              echo " `echo -e '\E[1;37;44m'`***** Thank you for visiting AWSome Pizzeria, $CustomerName.  See you soon!!`tput init`" 
              echo ""
              sleep 2
              exit
         fi
         ;;

      *) echo "------------------------------------------------------------------------"
         echo "                                                                        "
         echo "  Your order will be delivered in 45 minutes w/ $3.99 delivery fee      " 
         echo "                                                                        "
         echo "                   Would you like to order ?                               "
         echo ""
         echo ""
         read -p " 1 YES, start order  2. No, change to Carry Out  3. Stop and exit   ==>  " S_order
         
         Check_Entered_Number 3 $S_order
         S_order=$?
         
         if (( S_order == 1 )) ; then
         
              Delivery_Address
         
         elif (( S_order == 3 )) ; then 
              echo ""
              echo ""
              echo " `echo -e '\E[1;37;44m'`***** Thank you for visiting AWSome Pizzeria, $CustomerName.  See you soon!!`tput init`"  
              echo ""
              sleep 2
              exit
         fi
         ;;
esac

}
#--------------End of Function--------------------


#### Check if valid size entered  ###

function Check_Size() {
local size_check=0
     while (( $size_check == 0 ))   
     do   
          if [[ "${Size_Arr[@]}" =~ "$Ordered_Pizza_Size" ]]; then 
               size_check=1
          else
             echo ""
             read -p "Please select a correct size : [ S  M  L  X ]    ===> " Ordered_Pizza_Size
             Size_Arr=( s S m M l L x X xl XL xL Xl)
          fi
     done
}
#--------------End of Function--------------------

#### Check if valid quantity entered  ###
function Check_Qty() {
while ((O_Qty < 1))
do
      echo ""
      read -p "  Please enter the proper quntity  :  "  O_Qty
      echo ""
done
}
#--------------End of Function--------------------

# Get order size, calculate order price and order subtotal
function Cal_Size_price() {  # $1 : size  $2 : additional price $3 : Quantity

     if [ "$1" = "s" ] || [ "$1" = "S" ] ; then
         O_Size="Small"
         O_Price=`echo "$B_Pz_Price_S+$2" | bc`             #Small size price
     elif [ "$1" = "m" ] || [ "$1" = "M" ] ; then
         O_Size="Medium"
         O_Price=`echo "$B_Pz_Price_M+$2+0.40" | bc`        #Medium size price
     elif [ "$1" = "l" ] || [ "$1" = "L" ] ; then
        O_Size="Large" 
        O_Price=`echo "$B_Pz_Price_L+$2+0.60" | bc`        #Large size price
     else 
         O_Size="X-Large"
         O_Price=`echo "$B_Pz_Price_X+$2+1.70" | bc`       #XL size price
     fi
     
     O_Subtotal=`echo "$O_Price*$3" | bc`

}


#--------------End of Function--------------------


### Store's pick menu order

function Order_Stores_pick () {

local Price_Add=0.00     #Additional price to basic price
     
clear
echo ""
echo ""
echo "                               <<  Store's Pick Menu       >>   "
echo "* --------------------------------------------------------------------------------------- *"    
echo "*   1 Pepperoni   |    small: "`echo '$'`"12.20  Medium : "`echo '$'`"14.60  Large : "`echo '$'`"16.80  X-Large : "`echo '$'`"20.90   *" 
echo "*   2 Cheese      |    small: "`echo '$'`"11.00  Medium : "`echo '$'`"13.00  Large : "`echo '$'`"15.00  X-Large : "`echo '$'`"18.00   *" 
echo "*   3 Sausage     |    small: "`echo '$'`"12.20  Medium : "`echo '$'`"14.60  Large : "`echo '$'`"16.80  X-Large : "`echo '$'`"20.90   *" 
echo "* --------------------------------------------------------------------------------------- *"   
echo ""

read -p " Please select pizza : [ 1 - 3 ] " Ordered_Pizza_Name   #Pizza Name
echo ""

Check_Entered_Number 3 $Ordered_Pizza_Name
Ordered_Pizza_Name=$?
     
 
if (( Ordered_Pizza_Name == 1 )) ; then    
    O_Name="Pepperoni"
    Price_Add=1.20
elif (( Ordered_Pizza_Name == 2 )) ; then
    O_Name="Cheese"
else
    O_Name="Sausage"
    Price_Add=1.20
fi
     
read -p " Please select size : [ S  M  L  X ]  ===> " Ordered_Pizza_Size
Check_Size       # Check if valid size entered  ###  
echo ""     
read -p " Please enter the quantity of order : "  O_Qty
Check_Qty        # Check if valid quantity entered 
     
# Get order size, calculate order price and order subtotal
Cal_Size_price $Ordered_Pizza_Size $Price_Add  $O_Qty   # $1 : size  $2 : additional price  $3 : quantity 
                                                         #Return values : Pizza price, subtotal

     
}
#--------------End of Function--------------------


# Specialties menu order

function Order_Specialties () {

local Price_Add=0     #Additional price to basic price
clear
echo ""
echo ""
echo "                                   <<  Specialties Menu       >>   "
echo "* --------------------------------------------------------------------------------------------- *"    
echo "*   1 Meat                | small: "`echo '$'`"13.00  Medium : "`echo '$'`"15.40  Large : "`echo '$'`"17.60  X-Large : "`echo '$'`"21.70   *"
echo "*   2 Meatball Pepparoni  | small: "`echo '$'`"13.70  Medium : "`echo '$'`"16.10  Large : "`echo '$'`"18.30  X-Large : "`echo '$'`"22.40   *" 
echo "*   3 Hawaiian            | Small: "`echo '$'`"13.00  Medium : "`echo '$'`"15.40  Large : "`echo '$'`"17.60  X-Large : "`echo '$'`"21.70   *"
echo "* -------------------------------------------------------------------------------------------- *"   
echo ""


read -p " Please select pizza : [ 1 - 3 ] " Ordered_Pizza_Name   #Pizza Name
echo ""


Check_Entered_Number 3 $Ordered_Pizza_Name
Ordered_Pizza_Name=$?     


if (( Ordered_Pizza_Name == 1 )) ; then    
     O_Name="Meat"
     Price_Add=2.00
elif (( Ordered_Pizza_Name == 2 )) ; then
     O_Name="Meatball Pepparoni"
     Price_Add=2.70
else
     O_Name="Hawaiian"
     Price_Add=2.00
fi
     
read -p " Please select size : [ S  M  L  X ]  ===> " Ordered_Pizza_Size
Check_Size       # Check if valid size entered  ###  
echo ""      
read -p " Please enter the quantity of order : "  O_Qty
Check_Qty        # Check if valid quantity entered
     
# Get order size, calculate order price and order subtotal
Cal_Size_price $Ordered_Pizza_Size $Price_Add  $O_Qty   # $1 : size  $2 : additional price  $3 : quantity
     
}
#--------------End of Function--------------------


function Order_Meatless_Specialties() {

local Price_Add=0     #Additional price to basic price
clear

echo ""
echo ""
echo "                                   <<  Meatless Specialties Menu       >>   "
echo "* ----------------------------------------------------------------------------------------------- *"    
echo "*   1 Tomato Alfredo        |                                                                     *" 
echo "*   2 Garden Fresh          |  small: "`echo '$'`"13.00  Medium : "`echo '$'`"16.00  Large : "`echo '$'`"18.00  X-Large : "`echo '$'`"21.00   *" 
echo "*   3 Extra Cheesy Alfredo  |                                                                     *" 
echo "*   4 Tuscan Six Cheese     |                                                                     *" 
echo "* ----------------------------------------------------------------------------------------------- *"   
echo ""

read -p " Please select pizza : [ 1 - 4 ] " Ordered_Pizza_Name   #Pizza Name
echo ""

Check_Entered_Number 4 $Ordered_Pizza_Name
Ordered_Pizza_Name=$?  
   
if (( Ordered_Pizza_Name == 1 )) ; then    
         O_Name="Tomato Alfredo"
elif (( Ordered_Pizza_Name == 2 )) ; then
         O_Name="Garden Fresh "
elif (( Ordered_Pizza_Name == 3 )) ; then
         O_Name="Extra Cheesy Alfredo"
else
         O_Name="Tuscan Six Cheese"
fi
     
     
read -p " Please select size : [ S  M  L  X ]  ===> " Ordered_Pizza_Size
Check_Size       # Check if valid size entered  ###  
echo ""      
read -p " Please enter the quantity of order : "  O_Qty
Check_Qty        # Check if valid qyt entered
     
if [ "$Ordered_Pizza_Size" = "s" ] || [ "$Ordered_Pizza_Size" = "S" ] ; then
    O_Size="Small"
    O_Price=`echo "$B_Pz_Price_S+2.00" | bc`                                    #Small size price
elif [ "$Ordered_Pizza_Size" = "m" ] || [ "$Ordered_Pizza_Size" = "M" ] ; then
    O_Size="Medium"
    O_Price=`echo "$B_Pz_Price_M+3.00" | bc`                                    #Medium size price
elif [ "$Ordered_Pizza_Size" = "l" ] || [ "$Ordered_Pizza_Size" = "L" ] ; then
    O_Size="Large" 
    O_Price=`echo "$B_Pz_Price_L+3.00" | bc`                                    #Large size price
else 
    O_Size="X-Large"
    O_Price=`echo "$B_Pz_Price_X+3.00" | bc`                                    #XL size price
fi
 
O_Subtotal=`echo "$O_Price*$O_Qty" | bc`
}
#--------------End of Function--------------------


function Order_Today_Special {

echo ""
read -p " Please enter the quantity of Today's Special [1 - 2] :  "  O_Qty

while ((O_Qty != 1 )) && ((O_Qty != 2))
do
   echo ""
   read -p " Order limit is 2. Please enter 1 or 2 :  " O_Qty
   echo ""
done

O_Name="Today's Special - Cheese Pizza"
O_Size="Large"
O_Price=9.99
O_Subtotal=`echo "$O_Price*$O_Qty" | bc`
}
#--------------End of Function--------------------

# Add ordered pizza name, size, price, qty and subtotal to order array (cart).
function Add_Order_Cart () {
     index=$1
     Ordered_Name[index]=$O_Name
     Ordered_Qty[$index]=$O_Qty
     Ordered_Size[$index]=$O_Size
     Ordered_Price[$index]=$O_Price
     Ordered_Subtotal[$index]=$O_Subtotal
}
#--------------End of Function--------------------



###### Function Pizza Order 

function Order_Pizza () {

     clear
     echo ""
     echo ""
     echo "*  ------------------------------------------------------------------------------------  *"    
     echo "*   1 : Store’s picks        : Pepperoni, Cheese, Sausage                                *"
     echo "*   2 : Specialties          : Meat, Meatball pepperoni, Hawaiian                        *"
     echo "*   3 : Meatless Specialties : Fresh Spinach & Tomato Alfredo, Garden Fresh,             *"
     echo "*                              Extra Cheesy Alfredo, Tuscan Six Cheese                   *"
     echo "*  ------------------------------------------------------------------------------------  *"   
     echo ""
     read -p " Please enter your choice : [ 1 - 3 ] " O_choice  # Order_Menu of Pizza
     echo ""

Check_Entered_Number 3 $O_choice
O_choice=$?
   
     case $O_choice in
          1)  Order_Stores_pick ;;

          2)  Order_Specialties ;;

          *)  Order_Meatless_Specialties ;;
    esac

}
#--------------End of Function--------------------

function Order_Wings () {
       echo ""
       read -p " Select Sauce : 1. BBQ  2. Buffalo  3. Hot  4. Soy honey  :   " W_Sauce
       echo ""

Check_Entered_Number 4 $W_Sauce
W_Sauce=$?

       if (( W_Sauce == 1 )) ; then
          O_Name="Wings w/ BBQ"
       elif (( W_Sauce == 2 )) ; then
          O_Name="Wings w/ Buffalo"
       elif (( W_Sauce == 3 )) ; then
          O_Name="Wings w/ Hot"
       else
          O_Name="Wings w/ Soy Honey"
       fi
       
       O_Size="8 pcs"
       
       read -p " Please enter the quantity of order : "  O_Qty
       Check_Qty        # Check if valid quantity entered 
       O_Price=7.99
       O_Subtotal=`echo "$O_Price*$O_Qty" | bc`
}
#--------------End of Function--------------------

function Order_Pasta () {

       echo ""
       read -p " Select Pasta : 1. Chicken Alfredo   2. Italian Sausage Marinara  :   " C_Pasta
       echo ""

Check_Entered_Number 2 $C_Pasta
C_Pasta=$?
      
       if (( C_Pasta == 1 )) ; then
          O_Name="Chicken Alfredo"
       else
          O_Name="Italian Sausage Marinara"
       fi
       
       O_Size="Regular"
       
       read -p " Please enter the quantity of order : "  O_Qty
       Check_Qty        # Check if valid quantity entered 
       O_Price=6.99
       O_Subtotal=`echo "$O_Price*$O_Qty" | bc`
}
#--------------End of Function--------------------

function Order_Salad () {
       echo ""
       read -p " Select Salad : 1. Clasic Garden   2. Chicken Caesar  :   " C_Salad
       echo ""
       
Check_Entered_Number 2 $C_Salad
C_Salad=$?
       
       if (( C_Salad == 1 )) ; then
          O_Name="Clasic Garden"
       else
          O_Name="Chicken Caesar"
       fi
       
       O_Size="Regular"
       
       read -p " Please enter the quantity of order : "  O_Qty
       Check_Qty        # Check if valid quantity entered 
       O_Price=6.49
       O_Subtotal=`echo "$O_Price*$O_Qty" | bc`
}
#--------------End of Function--------------------

echo ""
function Order_Cheese_Bread () {
       echo ""
       O_Name="Wings w/ Soy Honey"
       O_Size="8 pcs"
       read -p " Please enter the quantity of order : "  O_Qty
       Check_Qty        # Check if valid quantity entered 
       O_Price=6.49
       O_Subtotal=`echo "$O_Price*$O_Qty" | bc`
}
#--------------End of Function--------------------



function Order_Sides ()  {
#
clear     

echo ""
echo "                         <<  Sides Menu       >>   "
echo "* ---------------------------------------------------------------------------------- *"    
echo "*   1 Wings (8-piece)        - "`echo '$'`"7.99 |  BBQ / Buffalo / Hot / Soy honey              *" 
echo "*   2 Pasta-Meat             - "`echo '$'`"6.99 |  Chicken Alfredo / Italian Sausage Marinara   *" 
echo "*   3 Salad                  - "`echo '$'`"6.49 |  Clasic Garden  / Chicken Caesar              *" 
echo "*   4 Cheese Bread (8-piece) - "`echo '$'`"6.49                                                 *" 
echo "* ---------------------------------------------------------------------------------- *"  
echo ""

read -p " Please select Side : [ 1 - 4 ] " Ordered_Side_Name   #Side Name

Check_Entered_Number 4 $Ordered_Side_Name
Ordered_Side_Name=$?
     
case $Ordered_Side_Name in 
     1)  Order_Wings ;;
     2)  Order_Pasta ;;
     3)  Order_Salad ;;
     *)  Order_Cheese_Bread ;;
esac

}
#--------------End of Function--------------------

function Order_Dessert () {

clear

echo ""
echo "            <<  Dessert Menu       >>   "
echo "* ------------------------------------------*"    
echo "*   1 Cinammon Sticks (8-piece)   -  "`echo '$'`"6.49  *" 
echo "*   2 Brownies        (8-piece)   -  "`echo '$'`"6.49  *" 
echo "* -------------------------------------------*"
echo ""

     read -p " Select Dessert : 1. Cinammon Sticks   2. Brownies  :   " C_Dessert
       echo ""

Check_Entered_Number 2 $C_Dessert
C_Dessert=$?
       
       if (( C_Dessert == 1 )) ; then
          O_Name="Cinammon Sticks"
       else
          O_Name="Brownies"
       fi
       
       O_Size="8 pcs"
       
       read -p " Please enter the quantity of order : "  O_Qty
       Check_Qty        # Check if valid quantity entered 
       O_Price=6.49
       O_Subtotal=`echo "$O_Price*$O_Qty" | bc`

}
#--------------End of Function--------------------

function Order_Drinks () {
#Coke/water only 20oz/Sprite/Dr.Pepper /fanta orange   20 oz bottle 2.19
#          2 liter  2.99 

local C_Drink=0
local Drink_Size=0
clear

echo ""
echo "                       <<      Drink Menu       >>"
echo " * ------------------------------------------------------------------------------* "   
echo " *  1. Coke   2. Sprite   3. Dr.Pepper   4. Fanta Orange   5. Water (20oz only)  * "
echo " *                                                                               * "
echo " *                         - 2 Liter bottle :  2.99                              * "
echo " *                         - 20 oz bottle   :  2.19                              * "
echo " * ------------------------------------------------------------------------------* " 
echo ""

read -p " Select Drink  [ 1 - 5 ]   :   "  C_Drink
echo ""

Check_Entered_Number 5 $C_Drink
C_Drink=$?
if (( C_Drink == 1 )) ; then
      O_Name="Coke"
elif (( C_Drink == 2 )) ; then
      O_Name="Sprite"
elif (( C_Drink == 3 )) ; then
      O_Name="Dr.Pepper"
elif (( C_Drink == 4 )) ; then
      O_Name="FAnta Orange"
else
      O_Name="Water"
fi
 
       
if (( C_Drink == 5 )) ; then   # Water : Only 20 oz available
       O_Size="20 oz"
       O_Price=2.19
else      
       read -p " Please select the size   1) 2 Liter    2) 20oz  [ 1 - 2 ]  ===> "  Drink_Size
       echo ""

       Check_Entered_Number 2 $Drink_Size
       Drink_Size=$?
       
       if (( Drink_Size == 1 )) ; then
           O_Size="2 Liter"
           O_Price=2.99
       else 
           O_Size="20 oz"
           O_Price=2.19
       fi
fi
 
read -p " Please enter the quantity of order : "  O_Qty
echo ""

Check_Qty        # Check if valid quantity entered 

O_Subtotal=`echo "$O_Price*$O_Qty" | bc`

}
#--------------End of Function--------------------


function Review_Cart () {
     #echo ""
     echo "                << Order List >> "
     echo "------------------------------------------------------"
     echo ""
        
     i=0
     Total_Price=0
     Temp_Price=0
     while (( i < Order_Count )) 
     do
       echo -ne "Order $((i+1)) : ${Ordered_Name[$i]}  ${Ordered_Size[$i]}  ${Ordered_Qty[$i]}  "
       echo "${Ordered_Price[$i]}   Sub Total : ${Ordered_Subtotal[$i]}"
       Temp_Price=`echo "$Total_Price+${Ordered_Subtotal[$i]}" | bc` 
       Total_Price=$Temp_Price
       i=$((i+1))
     done
     
     E_Tax=`echo "$Total_Price*0.06" | bc` 
     echo ""
     echo "-------------------------------------------------------"
     echo "    Total before Tax  :   "`echo '$'`"$Total_Price"
     if (( T_order == 2 )) ; then
        D_Charge=3.99 
        echo "    Delivery charge   :   "`echo '$'`"3.99"
     else D_Charge=0
     fi
     echo "    Tax               :   "`echo '$'`"$E_Tax"
     echo ""
     echo "------------------------------------------------------"
     Grand_Total=`echo "$Total_Price+$D_Charge+$E_Tax" | bc`
     echo "    Grand Total       :   "`echo '$'`"$Grand_Total                       "
     echo ""

}
#--------------End of Function--------------------

function Print_Receipt () {

     echo ""
     echo "-------------------------------------------------------"
     echo -e "         <<"`echo -e '\033[0;33m'`"   \e[3m\e[1mReceipt of Your Order\e[0m >>`tput init`"
     echo "-------------------------------------------------------"
     echo ""
     echo "   Name             :  $CustomerName "  
     echo "   Phone No         :  $PhoneNo"
     if (( T_order == 2 )) ; then
         echo "   Delivery address :  $D_addr"
     fi
     echo ""
     echo "-------------------------------------------------------"
     echo ""
     
     
     i=0
#     Total_Price=0
     while (( i < Order_Count )) 
     do
       echo -ne "Order $((i+1)) : ${Ordered_Name[$i]}  ${Ordered_Size[$i]}  ${Ordered_Qty[$i]}  "
       echo "${Ordered_Price[$i]}   Sub Total : ${Ordered_Subtotal[$i]}"
#       Total_Price=`echo "$Total_Price+$Ordered_Subtotal" | bc` 
       i=$((i+1))
     done
     
#     E_Tax=`echo "$Total_Price*0.06" | bc` 
     echo ""
     echo "-------------------------------------------------------"
     echo " Total before Tax  :   "`echo '$'`"$Total_Price"
     
     if (( T_order == 2 )) ; then
#        D_Charge=3.99 
        echo " Delivery charge   :   "`echo '$'`"3.99"
#       else D_Charge=0
     fi
     echo " Tax               :   "`echo '$'`"$E_Tax"
        #  Grand_Total=`echo "$Total_Price+$D_Charge+$E_Tax" | bc`
    
     if [ "$Tip_YN" == "Y" ] || [ "$Tip_YN" == "y" ] ; then
         echo " Tip               :   "`echo '$'`"$Tip_Amt"
     fi
     
     echo -e '\E[1;37;44m'
     echo "------------------------------------------------------"
     echo "   Grand Total       :   "`echo '$'`"$Final_Total                       "
     echo "------------------------------------------------------`tput init`"
     echo ""
     
     echo ""
     echo -e "    Thank you for your order at "`echo -e '\E[34;47m'`"\e[3m\e[1m AWSome Pizzeria \e[0m .`tput init`"
     if (( T_order == 1 )) ; then
         echo "    Your order will be ready at "`date -d '20 minutes' '+ %H : %M'`"."
     elif (( T_order == 2 )) ; then
         echo "    Your order will be delivered at "`date -d '40 minutes' '+ %H : %M'`"."
     fi
     echo ""
}
#--------------End of Function--------------------

 function pay_order () {
 echo ""
 echo "       << How would you like to pay? >> "
 read -p "    1. Credit card     2. Cash     :   "  P_Type
 echo ""
 
   Check_Entered_Number 2 $P_Type
   P_Type=$?
 
  if (( P_Type == 1 )) ; then
       echo ""
        read -p " *  Please Enter your card number ( NO SPACE )  : " Card_No
        read -p "                       Expiration date (MM/YY)  : " Ex_Date
        
        echo ""
        echo " * Card number : $Card_No   Expiration data : $Ex_Date. "
        read -p " Is card information correct ?    Y / N " Card_YN
            

       while [ "$Card_YN" != "Y" ] && [ "$Card_YN" != "y" ]    # when Name or Phone # is not correct
       do
         if [ "$Card_YN" = "N" ] || [ "$Card_YN" = "n" ]; then    # when Name or Phone # is not correct
           echo ""
           read -p " *  Please Enter your card number ( NO SPACE )  : " Card_No
           read -p "                       Expiration date (MM/YY)  : " Ex_Date
           echo ""
           echo " * Card number : $Card_No   Expiration data : $Ex_Date. "
           read -p " Is card information correct ?    Y / N " Card_YN
         else                                                   # when input is not valid -> ask to enter Y or N
           read -p "  Please enter Y (y) or N (n) ===> " Card_YN
         fi
       done
       
       sleep 1
       clear
       echo ""
       echo " * System is processing.....................*"
       sleep 3
       echo ""
       echo " Your order total amount $Final_Total is paid successfully !! "
     else 
        sleep 1
        clear
        echo ""
        echo " *   Please pay at our store or at your door. "
     fi
}
#---------------- end of function -------------


function Check_Out () {
     clear
     echo ""
     echo "           Customer Info                "
     echo "----------------------------------------"
     echo " Name             :  $CustomerName "  
     echo " Phone No         :  $PhoneNo"
     if (( T_order == 2 )) ; then
         echo " Delivery address :  $D_addr"
     fi
     echo "----------------------------------------"
     
     Review_Cart
     
     echo ""
     read -p " Would you like to add a tip?    Y or N  ===>  "  Tip_YN
     while [ "$Tip_YN" != "Y" ] && [ "$Tip_YN" != "y" ] && [ "$Tip_YN" != "N" ] && [ "$Tip_YN" != "n" ]  
     do
         echo ""
         read -p " Please enter    Y or N  ===>  "  Tip_YN
         echo ""
     done
     
     if [ "$Tip_YN" == "Y" ] || [ "$Tip_YN" == "y" ] ; then
         echo ""
         read -p " Please Enter a Tip amount   :   "`echo '$'`  Tip_Amt
         while (( Tip_Amt <=0 )) 
         do
            echo ""
            read -p "    Please enter a proper tip   :   "`echo '$'`  Tip_Amt
         done       
         echo ""
         
         Final_Total=`echo "$Grand_Total+$Tip_Amt" | bc`
         
         echo ""
         echo -e "          "`echo -e '\033[0;33m'`"\e[3m\e[1m--- Final Total   :   "`echo '$'`"$Final_Total ---\e[0m`tput init`" 
        # echo " --- Final Total   :   "`echo '$'`"$Final_Total ---"
     else
         Final_Total=$Grand_Total
     fi
            
     echo ""
     echo "           Would you like to make an order? "
     echo ""
     read -p "  1. YES, Pay now   2. Continu Shopping   3. Cancel Order [ 1 - 3 ]  :   " Make_Order
     
     Check_Entered_Number 3 $Make_Order
     Make_Order=$?
  
     if (( Make_Order == 1 )) ; then
        pay_order  
        sleep 1
        Print_Receipt
     elif (( Make_Order == 2 )); then
        echo "     Returning to Main Menu       "
        Keep_Order=1
        sleep 1  
     else
        echo ""
        echo -e " ***     Thank you for vising "`echo -e '\E[34;47m'`"\e[3m\e[1m AWSome Pizzeria \e[0m .`tput init`  See You soon !!      ***"
        echo ""
        echo ""
        sleep 1
        exit             # Finish ordering
    fi   
}
     
#--------------End of Function--------------------

#############   Main  ###########


declare -a Size_Arr
Size_Arr=( s S m M l L x X xl XL xL Xl)   # Pizza size check array

declare -a Ordered_choice   # Pizza, Sides, Desserts, Drinks
declare -a Ordered_name
declare -a Ordered_size
declare -a ordered_topoing
declare -a ordered_qty
declare -a ordered_price

B_Pz_Price_S=11.00  #Basic Pizza Price-Small
B_Pz_Price_M=13.00  #Basic Pizza Price-Medium
B_Pz_Price_L=15.00  #Basic Pizza Price-Large
B_Pz_Price_X=18.00  #Basic Pizza Price-XLarge


clear
echo "" 
echo -e '\E[1;37;44m'
echo " ****************************************************************************************** "
echo " *                           <<<  WELCOME to AWSome Pizzeria>>>                           * "
echo " *                                                                                        * "
echo " *   AWSomePizzria.com                1-800-123-7890            922 AWS St. NCI city, VA  * " 
echo " *                                                                                        * "     
echo " *                "`echo -e '\E[34;47m'`"Today’s special  : Large Cheese pizza  : "`echo '$'`"9.99  (Limit 2)"`echo -e '\E[1;37;44m'`"               * "
echo " *                                                                                        * "
echo " ****************************************************************************************** "
tput init

sleep 1
# Enter name, phone no
Client_Info

# Select Type of Order : Carry out or Delivery
Type_Order

# ==  Start orders
sleep 1
clear
Order_Count=0
Keep_Order=1

while ((Keep_Order == 1)) 
do
clear
echo -e '\E[1;37;44m'
echo " ****************************************************************************************** "
echo " *                                                                                        * " 
echo " *           1 : Pizza      2  : Sides      3  :  Desserts      4  : Drinks               * "
echo " *                                                                                        * "
echo " *           "`echo -e '\E[34;47m'`" 5 : Today's Special : Large Cheese pizza : "`echo '$'`"9.99  (Limit 2) "`echo -e '\E[1;37;44m'`"                * "
echo " *                                                                                        * "
echo " ****************************************************************************************** "
echo " *     << Pizza >>                                                                        * "    
echo " *      Store’s picks        : Pepperoni, Cheese, Sausage                                 * "
echo " *      Specialties          : Meat, Meatball pepperoni, Hawaiian                         * "
echo " *      Meatless Specialties : Fresh Spinach & Tomato Alfredo, Garden Fresh,              * "
echo " *                           Extra Cheesy Alfredo, Tuscan Six Cheese                      * "
echo " *     << Sides >>                                                                        * "
echo " *       wings      : BBQ/Buffalo/Hot/Soy honey                                           * "
echo " *       pasta-meat :  sauce/chicken alfredo                                              * "                     
echo " *       salad      :-Caesar salad/chicken salad                                          * "
echo " *       cheesy bread                                                                     * "
echo " *                                                                                        * "
echo " *     << Dessert >>                                                                      * "
echo " *       cinnamon sticks                                                                  * "
echo " *       brownies                                                                         * "
echo " *                                                                                        * "
echo " *     << Drinks >>                                                                       * "
echo " *      Coke/water/Sprite/Dr.Pepper                                                       * "
echo " *                                                                                        * "
echo " ****************************************************************************************** "
echo " *                                                                                        * " 
echo " *           1 : Pizza      2  : Sides      3  :  Desserts      4  : Drinks               * "
echo " *                                                                                        * "
echo " *           "`echo -e '\E[34;47m'`" 5 : Today's Special : Large Cheese pizza : "`echo '$'`"9.99  (Limit 2) "`echo -e '\E[1;37;44m'`"                * "
echo " *                                                                                        * "
echo " ****************************************************************************************** `tput init`"
tput init

echo ""
read -p "    **    What would you like to order?  select [ 1 - 5 ]  :   " Order_Menu   # Order catagory : Pizza, Sides, Desserts, Drinks, Extras

Check_Entered_Number 5 $Order_Menu
Order_Menu=$?
  
case $Order_Menu in
     1) sleep 1
        Order_Pizza  ;;
     2) sleep 1
        Order_Sides  ;;
     3) sleep 1
        Order_Dessert;;
     4) sleep 1
        Order_Drinks ;;
     *) 
        Order_Today_Special;;
esac
     sleep 1
     clear
     echo ""
     echo -e "           <<"`echo -e '\033[0;33m'`"   \e[3m\e[1mThis is your order\e[0m >>`tput init`"
     echo "--------------------------------------------"
     echo "   Pizza name : $O_Name "
     echo "   Size       : $O_Size "
     echo "   Price      : "`echo '$'`"$O_Price"
     echo "   Quantity   : $O_Qty  "
     echo "   Subtotal   : "`echo '$'`"$O_Subtotal"
     echo "--------------------------------------------"
     echo ""
     read -p "  Add this order to your cart ?    Y or N  ===>  "  Add_YN

     while [ "$Add_YN" != "Y" ] && [ "$Add_YN" != "y" ] && [ "$Add_YN" != "N" ] && [ "$Add_YN" != "n" ]  
     do
         echo ""
         read -p " Please enter Y or N  ==>  " Add_YN
         echo ""
     done
     
     clear
     if [ "$Add_YN" == "Y" ] || [ "$Add_YN" == "y" ] ; then
         Add_Order_Cart $Order_Count 
         sleep 1
         clear
         echo ""
         echo " * Your order has been added to your cart !! "
         Order_Count=$((Order_Count+1))
     else
         sleep 1
         clear
         echo ""
         echo " * Your order has been discarded !! "
     fi
     
     sleep 1
     echo ""
     echo ""
     echo "           What would you like to do next ?             "
     echo " ****************************************************** "
     echo " *   1 : Check out                                    * "
     echo " *   2 : Continue Shopping                            * "
     echo " *   3 : review Your Cart                             * " 
     echo " *   4 : Cancel all orders and Exit                   * "
     echo " ****************************************************** "
     echo ""
     
     read -p " Please select the option. [1 - 4] ==> "  After_Order_Option  
     
Check_Entered_Number 4 $After_Order_Option
After_Order_Option=$?

     case $After_Order_Option in
          1) 
             Keep_Order=0                    # Finish ordering
             sleep 1
             Check_Out
             ;;
          2) 
             echo ""
             echo "     Returning to Main Menu       "
             sleep 1                           
             ;;
          3) 
             sleep 1
             clear
             Review_Cart   # Review order
             
             echo ""
             echo ""
             echo "                << How would you like to proceed ? >>            "
             echo ""
             read -p " 1 : Check out  2 : Continue shopping  3 : Cancel all orders and Exit  => " How_Proceed
             echo ""
             
             Check_Entered_Number 3 $How_Proceed
             How_Proceed=$?
                          
             if (( How_Proceed == 1 )) ; then
                sleep 1
                Keep_Order=0       # Finish ordering
                Check_Out
             elif (( How_Proceed == 2 )) ; then
                echo "     Returning to Main Menu       "
                sleep 1 
             else (( How_Proceed == 3)) 
                sleep 1
                clear
                echo ""
                echo "              All your orders have been canceled."
                echo -e " ***     Thank you for vising "`echo -e '\E[34;47m'`"\e[3m\e[1m AWSome Pizzeria \e[0m .`tput init`  See You soon !!      ***"
                echo ""
                sleep 1
                Keep_Order=0       # Finish ordering
                exit
             fi
             ;;
          *) 
             sleep 1
             clear
             echo ""
             echo "              All your orders have been canceled."
             echo -e " ***     Thank you for vising "`echo -e '\E[34;47m'`"\e[3m\e[1m AWSome Pizzeria \e[0m .`tput init`  See You soon !!      ***"
             echo ""
             Keep_Order=0       # Finish ordering
             exit
          ;;          
     esac

done
    


