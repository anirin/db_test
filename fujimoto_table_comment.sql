-- 店舗関連
CREATE TABLE stores (
    id CHAR(26) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    shop_url VARCHAR(100) NOT NULL UNIQUE,
    receive_email VARCHAR(100) NOT NULL,
    logistics_api_key VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE email_templates (
    id CHAR(26) NOT NULL PRIMARY KEY,
    title VARCHAR(150) NOT NULL UNIQUE,
    subject TEXT NOT NULL,
    content TEXT NOT NULL,
    auto_flag BOOLEAN NOT NULL DEFAULT FALSE,
    store_id CHAR(26) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores(id)
);

CREATE TABLE categories (
    id CHAR(26) NOT NULL PRIMARY KEY,
    category_number INT UNSIGNED NOT NULL UNIQUE,
    content VARCHAR(100) NOT NULL UNIQUE,
    store_id CHAR(26) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores(id)
);

CREATE TABLE return_reasons (
    id CHAR(26) NOT NULL PRIMARY KEY,
    reason_number INT UNSIGNED NOT NULL UNIQUE,
    content CHAR(100) NOT NULL UNIQUE,
    responsibility SET('customer', 'business', 'shipping_company') NOT NULL,
    store_id CHAR(26) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores(id)
);


-- マネージャー
CREATE TABLE managers (
    id CHAR(26) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password CHAR(64) NOT NULL,
    authority ENUM('director', 'staff') NOT NULL DEFAULT 'director'
);

-- 商品情報

CREATE TABLE items (
    id CHAR(100) NOT NULL PRIMARY KEY,
    product_name CHAR(100) NOT NULL,
    maker CHAR(100) NOT NULL,
    stock INT UNSIGNED NOT NULL
);

-- 注文情報

CREATE TABLE orders (
    id CHAR(26) NOT NULL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    delivered_at DATE NOT NULL,
    payment_method ENUM('credit', 'cash') NOT NULL
);

-- 購入情報

CREATE TABLE order_items (
    id CHAR(26) NOT NULL PRIMARY KEY,
    item_id CHAR(100) NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    order_id CHAR(100) NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 返品ポリシー
CREATE TABLE return_policies (
    id CHAR(26) NOT NULL PRIMARY KEY,
    return_acceptance BOOLEAN NOT NULL DEFAULT TRUE,
    return_deadline INT UNSIGNED NOT NULL,
    responsibility SET('merchant_related', 'customer_related', 'courier_related') NOT NULL
);

-- 返品申請

CREATE TABLE return_requests (
    id CHAR(26) NOT NULL PRIMARY KEY,
    request_number CHAR(17) NOT NULL,
    requested_at DATE NOT NULL,
    store_id CHAR(26) NOT NULL,
    order_id CHAR(26) NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);


-- 取り扱い商品
CREATE TABLE handling_items (
    id CHAR(26) NOT NULL PRIMARY KEY,
    category_id CHAR(26) NOT NULL,
    return_policy_id CHAR(26) NOT NULL,
    store_id CHAR(26) NOT NULL,
    item_id CHAR(26) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (return_policy_id) REFERENCES return_policies(id),
    FOREIGN KEY (store_id) REFERENCES stores(id),
    FOREIGN KEY (item_id) REFERENCES items(id)
);

CREATE TABLE return_item_requests (
    id CHAR(26) NOT NULL PRIMARY KEY,
    handling_item_id CHAR(26) NOT NULL,
    return_reason CHAR(26) NOT NULL,
    description TEXT NOT NULL,
    return_action ENUM('refund', 'exchange') NOT NULL DEFAULT 'exchange',
    completed_at DATE,
    return_request_id CHAR(26) NOT NULL,
    item_id CHAR(100) NOT NULL,
    FOREIGN KEY (handling_item_id) REFERENCES handling_items(id),
    FOREIGN KEY (return_reason) REFERENCES return_reasons(id),
    FOREIGN KEY (return_request_id) REFERENCES return_requests(id),
    FOREIGN KEY (item_id) REFERENCES items(id)
);


CREATE TABLE default_return_policies (
    id CHAR(26) NOT NULL PRIMARY KEY,
    return_policy_id CHAR(26) NOT NULL,
    store_id CHAR(26) NOT NULL,
    FOREIGN KEY (return_policy_id) REFERENCES return_policies(id),
    FOREIGN KEY (store_id) REFERENCES stores(id)
);

CREATE TABLE photos (
    id CHAR(26) NOT NULL PRIMARY KEY,
    picture TEXT NOT NULL,
    return_item_requests_id CHAR(26) NOT NULL,
    FOREIGN KEY (return_item_requests_id) REFERENCES return_item_requests(id)
);

CREATE TABLE movies (
    id CHAR(26) NOT NULL PRIMARY KEY,
    movie TEXT NOT NULL,
    return_item_requests_id CHAR(26) NOT NULL,
    FOREIGN KEY (return_item_requests_id) REFERENCES return_item_requests(id)
);

-- 個別返品申請関連

CREATE TABLE comments (
    id CHAR(26) NOT NULL PRIMARY KEY,
    content TEXT NOT NULL,
    sent_at DATE NOT NULL,
    return_item_request_id CHAR(26) NOT NULL,
    FOREIGN KEY (return_item_request_id) REFERENCES return_item_requests(id)
);

CREATE TABLE approval_status (
    id CHAR(26) NOT NULL PRIMARY KEY,
    status ENUM('pending', 'approved', 'denied') NOT NULL DEFAULT 'pending',
    updated_at DATE NOT NULL,
    return_item_request_id CHAR(26) NOT NULL,
    FOREIGN KEY (return_item_request_id) REFERENCES return_item_requests(id)
);

CREATE TABLE response_status (
    id CHAR(26) NOT NULL PRIMARY KEY,
    status ENUM('completed', 'in_progress', 'not_started') NOT NULL,
    updated_at DATE NOT NULL,
    return_item_request_id CHAR(26) NOT NULL,
    FOREIGN KEY (return_item_request_id) REFERENCES return_item_requests(id)
);

-- 中間テーブル
CREATE TABLE rel_manager_store (
    id CHAR(26) NOT NULL PRIMARY KEY,
    manager_id CHAR(26) NOT NULL,
    store_id CHAR(26) NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES managers(id),
    FOREIGN KEY (store_id) REFERENCES stores(id)
);

CREATE TABLE rel_category_return_reason (
    id CHAR(26) NOT NULL PRIMARY KEY,
    category_id CHAR(26) NOT NULL,
    return_reason_id CHAR(26) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (return_reason_id) REFERENCES return_reasons(id)
);

CREATE TABLE rel_return_item_requests_return_reason (
    id CHAR(26) NOT NULL PRIMARY KEY,
    return_item_requests_id CHAR(26) NOT NULL,
    return_reason_id CHAR(26) NOT NULL,
    FOREIGN KEY (return_item_requests_id) REFERENCES return_item_requests(id),
    FOREIGN KEY (return_reason_id) REFERENCES return_reasons(id)
);
