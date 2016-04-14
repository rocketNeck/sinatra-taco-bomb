admin1 = Admin.create(email: "homestarflyer@gmail.com", password_digest: "admin")
admin2 = Admin.create(email: "rocketneck@gmail.com", password_digest: "password")


owner_name = ["bob","sam","dave"]
owner_email = ["1@gmail.com", "hello@gmail.com", "guy@gmail.com"]
owner_city = ["Denver", "Austin", "New York"]
owner_password = ["happyhappyjoyjoy", "largemarge", "powerranger"]
owner_payment_info = ["4444-2222-5555-1111", "1234-4321-1234-4321", "4444-5555-6666-7777"]
owner_admin_id = [1,1,2]

3.times do |i|
  Owner.create(
    name: owner_name[i],
    email: owner_email[i],
    city: owner_city[i],
    password_digest: owner_password[i],
    payment_info: owner_payment_info[i],
    admin_id: owner_admin_id[i]
    )
end



menu_item_name = ["Taco1", "Better Taco", "Magic Taco"]
menu_item_price = [7, 9, 8]
menu_item_descreption = [
  "A wonderful taco! Number 1!",
  "This taco is better than yours",
  "A taco to let you fly"
]
menu_item_img_path = [
  "https://farm4.staticflickr.com/3320/3309588755_e77d6f4d10_m.jpg",
  "https://farm7.staticflickr.com/6211/6364649617_3511eb1f3e_m.jpg",
  "https://farm1.staticflickr.com/143/317292213_da9faacca6_m.jpg"]
menu_item_current_num_prepped = [20, 21, 33]
menu_item_owner_id = [1,1,1]

3.times do |i|
  MenuItem.create(
    name: menu_item_name[i],
    price: menu_item_price[i],
    description: menu_item_descreption[i],
    img_path: menu_item_img_path[i],
    owner_id: menu_item_owner_id[i]
    )
end


customer_name = ["Yob", "Burn", "Moe"]
customer_email = ["anotherguy@gmail.com", "thebestone@gmail.com", "moesauce@yahoo.com"]
customer_password = ["yobber", "burnyyy", "moski"]
customer_payment_info = ["2222-3333-4444-5555", "4321-1234-4332-1111", "2222-2222-2222-2222"]

3.times do |i|
  Customer.create(
    name: customer_name[i],
    email: customer_email[i],
    password_digest: customer_password[i],
    payment_info: customer_payment_info[i]
    )
end
order_total = [22,44,33]
order_owner_id = [1,2,2]
order_customer_id = [1,2,3]
order_address = ["1516 Fenwick Pl, Fort Wayne, IN, 46804", "1111 Bent Road Rd., San Daigo, WV, 22222", "666 Masicare Ln., Waco, TX, 22233"]
order_status = ['closed', "pending", "open"]

3.times do |i|
  Order.create(
    total: order_total[i],
    owner_id: order_owner_id[i],
    customer_id: order_customer_id[i],
    status: order_status[i],
    address: order_address[i]
    )
end

3.times do |i|
  m = MenuItem.all.sample
  o = Order.create(
  total: 11,
  owner_id: 1,
  customer_id: 1,
  status: "open",
  address: "3452 sss"
  )
  o.menu_items << m
end
