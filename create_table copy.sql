CREATE TYPE authority AS ENUM ('Manager', 'Staff');
CREATE TYPE return_action AS ENUM('Refund', 'Exchange')
CREATE TYPE approval_status AS ENUM('Pending', 'Approved', 'Denied')
CREATE TYPE task_status AS ENUM('Completed', 'In_progress', 'Not_started')
CREATE TYPE payment_method AS ENUM (
    'Credit Card Payment',
    'Cod',
    'Bank Transfer',
    'Cvs Payment',
    'Post Payment',
    'Cash Payment',
    'Pay Easy',
    'Paypal',
    'No Payment',
    'Carrier Billing',
    'Electronic Money Payment',
    'Postal Transfer',
    'Registered Mail',
    'Sales On Credit',
    'Platform Payment',
    'Amazon Pay',
    'Amazon Payment',
    'Rakuten Pay',
    'Rakuten Bank Payment',
    'Rakuten Edy Payment',
    'Rakuten Id Payment',
    'Yahoo Wallet',
    'Yahoo Carrier Billing',
    'Line Pay',
    'Np Atobarai',
    'Nissen Collect Post Payment',
    'D Barai',
    'Dsk Cvs Payment',
    'Web Money',
    'Paypay Balance Payment',
    'Qoo10 Payment',
    'Shopify Payment Gateway'
);

CREATE TABLE IF NOT EXISTS stores (
    id CHAR(26) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    url VARCHAR(100) NOT NULL UNIQUE,
    receive_email VARCHAR(100) NOT NULL,
    logistics_api_key VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS email_templates (
    id CHAR(26) NOT NULL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    subject VARCHAR(150) NOT NULL,
    content TEXT NOT NULL,
    is_auto_reply BOOLEAN NOT NULL DEFAULT FALSE,
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_email_templates ON email_templates (store_id, title);

CREATE TABLE IF NOT EXISTS categories (
    id CHAR(26) NOT NULL PRIMARY KEY,
    number INT NOT NULL CHECK (number >= 0),
    content VARCHAR(100) NOT NULL,
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_content_categories ON categories (store_id, content);
CREATE INDEX idx_unmber_categories ON categories (store_id, number);

CREATE TABLE IF NOT EXISTS return_reasons (
    id CHAR(26) NOT NULL PRIMARY KEY,
    number INT CHECK (number >= 0) NOT NULL,
    content VARCHAR(100) NOT NULL,
	responsibility TEXT NOT NULL,
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_number_return_reasons ON categories (store_id, number);
CREATE INDEX idx_number_return_reasons ON categories (store_id, content);

CREATE TABLE IF NOT EXISTS managers (
    id CHAR(26) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password CHAR(64) NOT NULL,
    authority authority NOT NULL DEFAULT 'Manager'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS items (
    id CHAR(100) NOT NULL PRIMARY KEY,
    name CHAR(100) NOT NULL,
    maker CHAR(100) NOT NULL,
    stock INT CHECK (stock >= 0) NOT NULL
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_items ON items (store_id, id);

CREATE TABLE IF NOT EXISTS orders (
    id CHAR(26) NOT NULL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    delivered_at DATE NOT NULL,
    store_id CHAR(26) NOT NULL,
    payment_method payment_method NOT NULL
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_orders ON orders (store_id, id);

CREATE TABLE IF NOT EXISTS order_items (
    id CHAR(26) NOT NULL PRIMARY KEY,
    item_id CHAR(100) NOT NULL,
    quantity INT CHECK (quantity >= 0) NOT NULL,
    order_id CHAR(100) NOT NULL,
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_orders ON orders (store_id, order_id);

CREATE TABLE IF NOT EXISTS return_policies (
    id CHAR(26) NOT NULL PRIMARY KEY,
    return_acceptance BOOLEAN NOT NULL DEFAULT TRUE,
    return_deadline INT CHECK (return_deadline >= 0) NOT NULL,
    responsibility TEXT NOT NULL
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS return_requests (
    id CHAR(26) NOT NULL PRIMARY KEY,
    number CHAR(17) NOT NULL,
    requested_at DATE NOT NULL,
    store_id CHAR(26) NOT NULL,
    order_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_return_requests ON return_requests (store_id, id);

CREATE TABLE IF NOT EXISTS handling_items (
    id CHAR(26) NOT NULL PRIMARY KEY,
    category_id CHAR(26) NOT NULL,
    return_policy_id CHAR(26) NOT NULL,
    store_id CHAR(26) NOT NULL,
    item_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_handling_items ON handling_items (id, store_id);

CREATE TABLE IF NOT EXISTS return_item_requests (
    id CHAR(26) NOT NULL PRIMARY KEY,
    handling_item_id CHAR(26) NOT NULL,
    return_reason CHAR(26) NOT NULL,
    description TEXT NOT NULL,
	return_action return_action NOT NULL DEFAULT 'Exchange' 
    completed_at DATE,
    return_request_id CHAR(26) NOT NULL,
    item_id CHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_return_item_requests ON return_item_requests (id, return_request_id);

CREATE TABLE IF NOT EXISTS default_return_policies (
    id CHAR(26) NOT NULL PRIMARY KEY,
    return_policy_id CHAR(26) NOT NULL,
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS images (
    id CHAR(26) NOT NULL PRIMARY KEY,
    image TEXT NOT NULL,
    return_item_requests_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_images ON images (id, return_request_id);

CREATE TABLE IF NOT EXISTS movies (
    id CHAR(26) NOT NULL PRIMARY KEY,
    movie TEXT NOT NULL,
    return_item_requests_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_movies ON movies (id, return_request_id);

CREATE TABLE IF NOT EXISTS comments (
    id CHAR(26) NOT NULL PRIMARY KEY,
    content TEXT NOT NULL,
    sent_at DATE NOT NULL,
    return_item_request_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_comments ON comments (id, return_request_id);

CREATE TABLE IF NOT EXISTS approval_status (
    id CHAR(26) NOT NULL PRIMARY KEY,
    status approval_status NOT NULL DEFAULT 'Pending',
    return_item_request_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_approval_status ON approval_status (id, return_request_id);

CREATE TABLE IF NOT EXISTS task_status (
    id CHAR(26) NOT NULL PRIMARY KEY,
	status task_status NOT NULL
    return_item_request_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_id_task_status ON task_status (id, return_request_id);

CREATE TABLE IF NOT EXISTS rel_manager_store (
    id CHAR(26) NOT NULL PRIMARY KEY,
    manager_id CHAR(26) NOT NULL,
    store_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS rel_category_return_reason (
    id CHAR(26) NOT NULL PRIMARY KEY,
    category_id CHAR(26) NOT NULL,
    return_reason_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS rel_return_item_requests_return_reason (
    id CHAR(26) NOT NULL PRIMARY KEY,
    return_item_requests_id CHAR(26) NOT NULL,
    return_reason_id CHAR(26) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);