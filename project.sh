#! /bin/bash

## Team name : AWSome Quartet
##   Limit input error upto 3 times

clear

echo ""
echo "                            <<<  WELCOME to AWSome Pizzeria >>>        "
echo "
echo "******************************************************************************************"
echo "*                                                                                        *"
echo "*     Today’s special  : Large Cheese pizza  : $9.99 !!!                                 *"
echo "*                                                                                        *"
echo "******************************************************************************************"
### Take customer’s name and phone number
# Variable : CustomerName, PhoneNo
function NameNPhone () {
   echo "    << Please Enter your full name and phone number to start your order >>  "
   read -p "   Your name   :       " CustomerName
   read -p "   Phone No.   :       " PhoneNo
  # return $CustomerName $PhoneNo
}
# Confirm customer’s name and phone number
# Variable : C_Info ( Y or N )
function CheckInfo() {
  echo ""
  echo "   Your name is $CustomerName  and  Phone No. is $PhoneNo  "
  echo "" 
 read -p " Is all information correct ?    Y or N ===> " C_Info
}
# input confirmation
function confirmYN () {
     YorN=$1
        while [ "$YorN" != "Y" ] && [ "$YorN" != "y" ]    
        do 
                if [ "$YorN" = "N" ] || [ "$YorN" = "n" ]; then    # Type of order input is not correct
                   echo ""
                   echo " ***** Thank you for visiting AWSome Pizzeria, $CustomerName.  See you soon!! "   # Stop ordering
                  sleep 3
                   exit
              else 
                  echo "You entered $YorN"
                  read -p "  Please enter Y (y) or N (n) ===> " YorN     # Type of order input is not correct
              fi
          done
}
# Enter name, phone no
NameNPhone         #function : enter full name and phone number
CheckInfo                #function : validate name and phone number
while [ "$C_Info" != "Y" ] && [ "$C_Info" != "y" ]    # when Name or Phone # is correct
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
clear
                   
echo " ----------------- Select Type of Order ---------------"
echo ""
read -p "               1: Carry Out       2: Delivery     =>        " T_order    #T_order : 1 -> Carrry out 2 -> Delivery
echo ""
echo ""
echo "--------------------------------------------------------------------------------------------"
case $T_order in
      1) read -p "Your order will be ready to pick up in 30 minutes. Would like to start orders?  Y or N   ==>  " S_order
         confirmYN "$S_order"  ;;
      2) read -p "Your order will be delivered in 45 minutes and $5 delivery fee. Would like to start orders?  Y or N   ==>  " S_order
         confirmYN "$S_order"
         read -p "    Please enter Delivery Address    :     "  D_addr
         echo ""
         read -p " Is Delivery address $D_addr?     Y or N ====>   "  C_addr
         while [ "$C_addr" != "Y" ] && [ "$C_addr" != "y" ]    
         do 
              if [ "$C_addr" = "N" ] || [ "$C_addr" = "n" ]; then    # Type of order input is not correct
                   echo ""
                   read -p "    Please enter correct delivery Address    :     "  D_addr
                   echo ""
                   read -p "  Is Delivery address $D_addr?     Y or N ====>   "  C_addr
              else
                 echo "" 
                 echo "You entered $C_addr"
                 read -p "  Please enter Y (y) or N (n) ===> " C_addr     # Type of order input is not correct
              fi
          done  ;;
esac
