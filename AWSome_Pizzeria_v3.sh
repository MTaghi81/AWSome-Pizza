#! /bin/bash

## Team name : AWEsome Quartet
##   Limit input error upto 3 times



### Take customer’s name and phone number
# Variable : CustomerName, PhoneNo

function NameNPhone () {
   echo "    <<   Enter your name and phone number to start your order >>  "
   read -p "   Your name   :       " CustomerName
   read -p "   Phone No.   :       " PhoneNo
  # return $CustomerName $PhoneNo
}
#--------------End of Function--------------------

# Confirm customer’s name and phone number :  Variable : C_Info ( Y or N )

function CheckInfo() {
  echo ""
  read -p "   Your name is $CustomerName  and  Phone No. is $PhoneNo. Correct?  Y or N  ===> " C_Info
}
#--------------End of Function--------------------

# Ask to proceed ordering confirmation

function confirmYN () {
     local YorN=$1
        while [ "$YorN" != "Y" ] && [ "$YorN" != "y" ]    
        do 
                if [ "$YorN" = "N" ] || [ "$YorN" = "n" ]; then    # Type of order input is not correct
                   echo ""
                   echo " ***** Thank you for visiting AWSome Pizza, $CustomerName.  See you soon!! "   # Stop ordering
                  sleep 3
                   exit
              else 
               #   echo "You entered $YorN"
                  read -p "  Please enter Y (y) or N (n) ===> " YorN     # Type of order input is not correct
              fi
          done
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
             read -p "  Please select a correct size : [ S  M  L  X ]    ===> " Ordered_Pizza_Size
             echo " You entered $Ordered_Pizza_Size "
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

##### Add ordered pizza size, price, and qty to order array (cart).  #############


#function Add_Order_Cart( ) {
#     local O_Name=$1
#     local O_Size=$2
#     local A_Price=$3
#     local O_qty=$4
     
#     Ordered_Name=$O_Name
#     Ordered_Qty=$O_qty
 

 #    Ordered_Price=`echo "$O_Price+2.40" | bc`
 #    echo "** Ordered_Price = $Ordered_Price"
 
#     if [ "$O_Size" = "s" ] || [ "$O_Size" = "S" ] ; then
#         Ordered_Size="Small"
#         Ordered_Price=`echo "$B_Pz_Price_S+$A_Price" | bc`            #Small size price
#     elif [ "$O_Size" = "m" ] || [ "$O_Size" = "M" ] ; then
#             Ordered_Size="Medium"
#             Ordered_Price=`echo "$B_Pz_Price_M+$A_Price" | bc`        #Medium size price
#     elif [ "$O_Size" = "l" ] || [ "$O_Size" = "L" ] ; then
#        Ordered_Size="Large" 
#        Ordered_Price=`echo "$B_Pz_Price_L+$A_Price" | bc`             #Large size price
#     else 
#         Ordered_Size="X-Large"
#         Ordered_Price=`echo "$B_Pz_Price_X+$A_Price" | bc`            #XL size price
#     fi
     
#     Ordered_Subtotal=`echo "$Ordered_Price*$O_qty" | bc`
# } 
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
     
     echo "O_price = $O_Price, O_Qty = $O_Qty" 
     O_Subtotal=`echo "$O_Price*$3" | bc`

}


#--------------End of Function--------------------


### Store's pick menu order

function Order_Stores_pick () {

local Price_Add=0.00     #Additional price to basic price
     

echo ""
echo ""
echo "                                 <<  Store's Pick Menu       >>   "
echo "* --------------------------------------------------------------------------------------- *"    
echo "*   1 Pepperoni   |    small: "`echo '$'`"12.20  Medium : "`echo '$'`"14.60  Large : "`echo '$'`"16.80  X-Large : "`echo '$'`"20.90   *" 
echo "*   2 Cheese      |    small: "`echo '$'`"11.00  Medium : "`echo '$'`"13.00  Large : "`echo '$'`"15.00  X-Large : "`echo '$'`"18.00   *" 
echo "*   3 Sausage     |    small: "`echo '$'`"12.20  Medium : "`echo '$'`"14.60  Large : "`echo '$'`"16.80  X-Large : "`echo '$'`"20.90   *" 
echo "* --------------------------------------------------------------------------------------- *"   
echo ""

read -p " Please select pizza : [ 1 - 3 ] " Ordered_Pizza_Name   #Pizza Name
echo ""
     
while ((Ordered_Pizza_Name < 1)) || ((Ordered_Pizza_Name > 3))
do
     echo ""
     read -p "  Please enter the number [1 - 3]    ===> "  Ordered_Pizza_Name
     echo ""
done
 
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
     
read -p " Please enter the quantity of order : "  O_Qty
Check_Qty        # Check if valid quantity entered 
     
# Get order size, calculate order price and order subtotal
Cal_Size_price $Ordered_Pizza_Size $Price_Add  $O_Qty   # $1 : size  $2 : additional price  $3 : quantity

     
}
#--------------End of Function--------------------


# Specialties menu order

function Order_Specialties () {


local Price_Add=0     #Additional price to basic price

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
     
while ((Ordered_Pizza_Name < 1)) || ((Ordered_Pizza_Name > 3))
do
     echo ""
     read -p "  Please enter the number [1 - 3]    ===> "  Ordered_Pizza_Name
     echo ""
done
 
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
     
read -p " Please enter the quantity of order : "  O_Qty
Check_Qty        # Check if valid quantity entered
     
# Get order size, calculate order price and order subtotal
Cal_Size_price $Ordered_Pizza_Size $Price_Add  $O_Qty   # $1 : size  $2 : additional price  $3 : quantity
     
}
#--------------End of Function--------------------


function Order_Meatless_Specialties() {

local Price_Add=0     #Additional price to basic price


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
     
while ((Ordered_Pizza_Name < 1)) || ((Ordered_Pizza_Name > 4))
do
      echo ""
      read -p "  Please enter the number [1 - 4]    ===> "  Ordered_Pizza_Name
      echo ""
done
 
 
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
 
 echo "O_price = $O_Price, O_Qty = $O_Qty"    
O_Subtotal=`echo "$O_Price*$O_Qty" | bc`
}
#--------------End of Function--------------------


function Order_Today_Special {

echo ""
read -p " Please enter the quantity of Today's Special [1 - 2] :  "  O_Qty

while ((O_Qty != 1 )) && ((O_Qty != 2))
do
   echo ""
   read -p " Order lmit is 2. Please enter 1 or 2 :  " O_Qty
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




#--------------End of Function--------------------

###### Function Pizza Order 

function Order_Pizza () {
     echo ""
     echo "*  ------------------------------------------------------------------------------------  *"    
     echo "*   1 : Store’s picks        : Pepperoni, Cheese, Sausage                                *"
     echo "*   2 : Specialties          : Meat, Meatball pepperoni, Hawaiian                        *"
     echo "*   3 : Meatless Specialties : Fresh Spinach & Tomato Alfredo, Garden Fresh,             *"
     echo "*                              Extra Cheesy Alfredo, Tuscan Six Cheese                   *"
     echo "*   4 : Create Your Own                                                                  *"
     echo "*  ------------------------------------------------------------------------------------  *"   
     echo ""
     read -p " Please enter your choice : [ 1 - 4 ] " O_choice  # Order_Menu of Pizza
     echo ""

     while ((O_choice < 0)) || ((O_choice > 4))
     do
          echo ""
          read -p "  Please enter the number [1 - 4]    ===> "  O_choice
          echo ""
     done
    
    
     case $O_choice in
          1)  Order_Stores_pick ;;

          2)  Order_Specialties ;;

          3)  Order_Meatless_Specialties ;;

          *)  Order_Create_Own ;;
    esac

}
#--------------End of Function--------------------



function Order_Sides ()  {

echo "Order Sides"

}
#--------------End of Function--------------------

function Order_Dessert () {
echo "Order Dessert"


}
#--------------End of Function--------------------

function Order_Drinks () {

echo "Order Drinks"

}
#--------------End of Function--------------------

function Order_Extrass () {

echo "Order Extras"

}
#--------------End of Function--------------------

function Review_Cart () {
     sleep 1
     echo ""
     echo "     << Review Your Order >> "
     echo "-------------------------------------"
        
     i=0
     Total_Price=0
     Temp_Price=0
     while (( i < Order_Count )) 
     do
       echo -ne "Order $((i+1)) : ${Ordered_Name[$i]}  ${Ordered_Size[$i]}  ${Ordered_Qty[$i]}  "
       echo "${Ordered_Price[$i]}   Sub Total : ${Ordered_Subtotal[$i]}"
       Temp_Price=`echo "$Total_Price+${Ordered_Subtotal[$i]}" | bc` 
       Total_Price=$Temp_Price
       echo "Total price $Total_Price Temp : $Ttemp_Price"
       i=$((i+1))
     done
     
     E_Tax=`echo "$Total_Price*0.06" | bc` 
     echo "-------------------------------------------------------"
     echo " Total before Tax  :   "`echo '$'`"$Total_Price"
     if (( T_order == 2 )) ; then
        D_Charge=3.99 
        echo " Delivery charge   :   "`echo '$'`"3.99"
     else D_Charge=0
     fi
     echo " Tax               :   "`echo '$'`"$E_Tax"
     echo "------------------------------------------------------"
     Grand_Total=`echo "$Total_Price+$D_Charge+$E_Tax" | bc`
     echo " Grand Total       :   "`echo '$'`"$Grand_Total "
     echo ""

}
#--------------End of Function--------------------

function Print_Receipt () {

     sleep 2
     clear
     echo ""
     echo "     << Receipt of Your Order >> "
     echo "-------------------------------------"
     echo ""
     echo " Name             :  $CustomerName "  
     echo " Phone No         :  $PhoneNo"
     if (( T_order == 2 )) ; then
         echo " Delivery address :  $D_addr"
     fi
     echo ""
     echo "----------------------------------------"
     
     
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
     echo "------------------------------------------------------"
     echo " Grand Total       :   "`echo '$'`"$Final_Total "
     echo ""
     
     echo ""
     echo " Tank you for your order "
     if (( T_order == 1 )) ; then
         echo " Your order will be ready at "`date -d '20 minutes' '+ %H : %M'`"."
     elif (( T_order == 2 )) ; then
         echo " Your order will be delivered at "`date -d '40 minutes' '+ %H : %M'`"."
     
}
#--------------End of Function--------------------

function Check_Out () {
     sleep 1
     clear
     echo ""
     echo "----------------------------------------"
     echo " Name             :  $CustomerName "  
     echo " Phone No         :  $PhoneNo"
     if (( T_order == 2 )) ; then
         echo " Delivery address :  $D_addr"
     fi
     echo ""
     echo "----------------------------------------"
     
     Review_Cart
     
     echo ""
     read -p " Would you like to add tips?    Y / N " Tip_YN
     while [ "$Tip_YN" != "Y" ] && [ "$Tip_YN" != "y" ] && [ "$Tip_YN" != "N" ] && [ "$Tip_YN" != "n" ]  
     do
         echo ""
         read -p " Please enter Y or N  ==>  " Tip_YN
         echo ""
     done
     
     if [ "$Tip_YN" == "Y" ] || [ "$Tip_YN" == "y" ] ; then
         echo ""
         read -p "Please Enter Tip amount   :   "`echo '$'`  Tip_Amt
         echo ""
         Final_Total=`echo "$Grand_Total+$Tip_Amt" | bc`
         echo " --- Final Total   :   "`echo '$'`"$Final_Total ---"
     else
         Final_Total=$Grand_Total
     fi
          
     echo ""
     echo "       << How would you like to pay? >> "
     read -p " *   1. Credit card     2. Cash     :   "  P_Type
     echo ""
     
     while (( P_Type <0 )) || (( P_Type > 2))
     do
       echo ""
       read -p " Please enter the number [1-2]   :   " P_Type
       echo ""
     done 
     
     if (( P_Type == 1 )) ; then
        echo ""
        read -p "Please Enter your card number ( NO SPACE ) : " Card_No
        read -p "                  Expiration date (MM/YY)  : " Ex_Date
     else
        echo " Please pay at the store or your door. "
     fi
     
     echo ""
     echo "------------------------------------------------------"
     read -p "   1.  Mke an Order    2. Cancel Order [ 1 -2 ]  :   " Make_Order
     
     while (( $Make_Order < 0 )) || (( $Make_Order > 2 ))  
     do
         echo ""
         read -p " Please enter [ 1 - 2 ] ==>  " Pay_Now
         echo ""
     done
     
     if (( Make_Order == 1 )) ; then
        echo ""
        echo " Payment completed successfully !! "
        Print_Receipt
     else
        echo ""
        echo " ***     Thank you for vising us. See You soon !!      ***"
        echo ""
        exit             # Finish ordering
    fi   
}
     
#--------------End of Function--------------------

#####   Main Code
declare -a Size_Arr
Size_Arr=( s S m M l L x X xl XL xL Xl)

declare -a Ordered_choice   # Pizza, Sides, Desserts, Drinks, Extras
declare -a Ordered_name
declare -a Ordered_size
declare -a ordered_topoing
declare -a ordered_qty
declare -a ordered_price

B_Pz_Price_S=11.00  #Basic Pizza Price-Small
B_Pz_Price_M=13.00  #Basic Pizza Price-Medium
B_Pz_Price_L=15.00  #Basic Pizza Price-Large
B_Pz_Price_X=18.00  #Basic Pizza Price-XLarge
#IsPizza # True -> 



clear
echo ""
echo "                            <<<  WELCOME to AWSome Pizzeria>>>        "
echo "" 
echo -e '\033[0;31m'
echo "******************************************************************************************"
echo "*                                                                                        *"     
echo "*     Today’s special  : Large Cheese pizza  : "`echo '$'`"9.99         (Limit 2)               *"
echo "*                                                                                        *"
echo "******************************************************************************************"
tput init


# Enter name, phone no
NameNPhone         #function : enter name and phone number
CheckInfo                #function : validate name and phone number

while [ "$C_Info" != "Y" ] && [ "$C_Info" != "y" ]    # when Name or Phone # is not correct
do
   if [ "$C_Info" = "N" ] || [ "$C_Info" = "n" ]; then    # when Name or Phone # is not correct
       echo ""
       NameNPhone
       CheckInfo
   else                                                                               # when input is not valid -> ask to enter Y or N
       echo ""
       read -p "  Please enter Y (y) or N (n) ===> " C_Info
   fi
done



echo ""     
echo ""          
echo "                <<   Select Type of Order   >>"
echo ""
read -p "           1: Carry Out       2: Delivery     =>        " T_order    #T_order : 1 -> Carrry out 2 -> Delivery
echo ""
echo ""
case $T_order in
      1) echo "  Your order will be ready to pick up in 20 minutes." S_order  #S_order : start order Y or N
         read -p "  Would like to start orders?  Y or N   ==>  " S_order
         confirmYN "$S_order"  ;;

      2) echo "  Your order will be delivered in 45 minutes and extra "`echo "$"`"3.99 delivery fee. "
         read -p "  Would like to start orders?  Y or N   ==>  " S_order

         confirmYN "$S_order"

         echo ""
         read -p " *     Please enter Delivery Address    :     "  D_addr  # Delivery Address
         echo ""
         read -p " Delivery address $D_addr. Correct?     Y or N ====>   "  C_addr

         while [ "$C_addr" != "Y" ] && [ "$C_addr" != "y" ]    
         do 
              if [ "$C_addr" = "N" ] || [ "$C_addr" = "n" ]; then    # Type of order input is not correct
                   echo ""
                   read -p "    Please enter correct delivery Address    :     "  D_addr   # Deliverty address
                   echo ""
                   read -p "  Is Delivery address $D_addr?     Y or N ====>   "  C_addr    # IS entered address correct?
              else
                 echo "" 
                 echo "You entered $C_addr"
                 read -p "  Please enter Y (y) or N (n) ===> " C_addr     # Y or N input is not correct
              fi
         done  ;;
esac



# ==============  Start orders
sleep 1
clear
Order_Count=0
Keep_Order=1

echo "Keep Order = $Keep_Order"
while ((Keep_Order == 1)) 
do

echo "******************************************************************************************"
echo "*                                                                                        *" 
echo "*     1 : Pizza      2  : Sides   3  :  Desserts    4  : Drinks      5  :  Extras        *"
echo -ne "*                                                                                        *"
echo -e '\033[0;31m'
echo "*     6 : Today's Special : Large Cheese pizza  : "`echo '$'`"9.99  (Limit 2)                       *"
tput init
echo "*                                                                                        *"
echo "******************************************************************************************"
echo "*  << Pizza >>                                                                           *"    
echo "*   Store’s picks        : Pepperoni, Cheese, Sausage                                    *"
echo "*   Specialties          : Meat, Meatball pepperoni, Hawaiian                            *"
echo "*   Meatless Specialties : Fresh Spinach & Tomato Alfredo, Garden Fresh,                 *"
echo "*                           Extra Cheesy Alfredo, Tuscan Six Cheese                      *"
echo "*   Create Your Own                                                                      *"
echo "*  << Sides >>                                                                           *"
echo "*    wings      : BBQ/Buffalo/Hot/Soy honey                                              *"
echo "*    pasta-meat :  sauce/chicken alfredo                                                 *"                     
echo "*    salad      :-Caesar salad/chicken salad                                             *"
echo "*    cheesy bread                                                                        *"
echo "*                                                                                        *"
echo "*  << Dessert >>                                                                         *"
echo "*    cinnamon sticks                                                                     *"
echo "*    brownies                                                                            *"
echo "*                                                                                        *"
echo "*  << Drinks >>                                                                          *"
echo "*   Coke/water/Sprite/Dr.Pepper                                                          *"
echo "*   << Extras >>                                                                         *"
echo "*                                                                                        *"
echo "******************************************************************************************"
echo "*                                                                                        *" 
echo "*     1 : Pizza      2  : Sides   3  :  Desserts    4  : Drinks      5  :  Extras        *"
echo -ne "*                                                                                        *"
echo -e '\033[0;31m'
echo "*     6 : Today's Special : Large Cheese pizza  : "`echo '$'`"9.99  (Limit 2)                       *"
tput init
echo "*                                                                                        *"
echo "******************************************************************************************"

echo ""
read -p "    **    What would you like to order?  select [ 1 - 6 ]  :   " Order_Menu   # Order catagory : Pizza, Sides, Desserts, Drinks, Extras
while (( Order_Menu < 1)) || (( Order_Manu > 6))
do
          echo ""
          read -p "  Please enter the number [1 - 5]    ===> "  Order_Manu
          echo ""
done

case $Order_Menu in
     1) Order_Pizza  ;;
     2) Order_Sides  ;;
     3) Order_Dessert;;
     4) Order_Drinks ;;
     5) Order_Extras ;;
     *) Order_Today_Special;;
esac
       
     sleep 1
     clear
     echo ""
     echo ""
     echo ""
     echo "    << This is your order >> "
     echo "----------------------------------------"
     echo " Pizza name : $O_Name "
     echo " Size       : $O_Size "
     echo " Price      : "`echo '$'`"$O_Price"
     echo " Quantity   : $O_Qty  "
     echo " Subtotal   : "`echo '$'`"$O_Subtotal"
     echo "--------------------------------------------"
     echo ""
     echo "    How to prodeed ? "
     echo "* 1 : Check out "
     echo "* 2 : Add to Cart and Continue ordering "
     echo "* 3 : cancel this order and return to main menu "
     echo "* 4 : Review Your Cart" 
     echo "* 5 : Cancel all orders and Exit "
     read -p " Please select the option. [1 - 5] ==> "  After_Order_Option  
     
     while ((After_Order_Option < 1)) || ((After_Order_Option > 5))
     do
          echo ""
          read -p "  Please enter the number [1 - 5]  :  "  After_Order_Option
          echo ""
     done

     case $After_Order_Option in
          1) 
             Add_Order_Cart $Order_Count     # Add order to order cart
             Keep_Order=0                    # Finish ordering
             Order_Count=$((Order_Count+1))  # return to main menu
             Check_Out
             
          ;;
          2) 
             Add_Order_Cart $Order_Count     # Add order to order cart
             Order_Count=$((Order_Count+1))
                           
          ;;
          3) # Discard all actions and return to main menu
          ;;
          4) 
             Add_Order_Cart $Order_Count     # Add order to order cart
             Order_Count=$((Order_Count+1))
             Review_Cart   # Review order
             echo "    How to prodeed ? "
             read -p " 1 : Check out  2 : Continue shopping  3 : Cancel all orders and Exit  => " How_Proceed
             echo ""
             
             while ((How_Proceed < 1)) || ((How_Proceed > 3))
             do
                 echo ""
                 read -p "  Please enter the number [1 - 5]  :  "  How_Proceed
                 echo ""
             done
             
             if (( How_Proceed == 1 )) ; then
                Check_Out
                Keep_Order=0       # Finish ordering
             elif (( How_Proceed == 3)) ; then
                echo ""
                echo " ***     Thank you for vising us. See You soon !!      ***"
                echo ""
                Keep_Order=0       # Finish ordering
                exit
             fi
          ;;
          *) 
             echo ""
             echo " ***     Thank you for vising us. See You soon !!      ***"
             echo ""
             Keep_Order=0       # Finish ordering
             exit
          ;;          
     esac

done
    


