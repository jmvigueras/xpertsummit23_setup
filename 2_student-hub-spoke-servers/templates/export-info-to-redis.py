# --------------------------------------------------------------------------------------------
# Populate cluster data to Redis DB
#
# jvigueras@fortinet.com
# --------------------------------------------------------------------------------------------
import base64
import redis

def connect_db(host, port, password):
    """ Connect to Redis DB """
    try:
        r = redis.Redis(host=host, port=port, password=password)
        return r
    except Exception as e:
        print(f"Failed to connect to Redis: {e}")
        return None

def write_db(db_conn, key_value_pairs):
    """ Write key-value pairs to Redis """
    try:
        for key, value in key_value_pairs.items():
            db_conn.set(key, value)
    except Exception as e:
        print(f'Error writing key-value pairs to Redis: {e}')

def main():
    try:
        # Key values to write
        key_pair_public_key = '${public_key}'
        key_pair_private_key = '${private_key}'

        # Write key-pairs to Redis DB
        host = '${db_host}'
        port = '${db_port}'
        password = '${db_pass}'
        prefix = '${db_prefix}'
        separator = '_'

        db_conn = connect_db(host,port,password)
        if db_conn:
             # Define the key-value pairs to write
            key_value_pairs = {
                prefix+separator+'key_pair_public_key': key_pair_public_key,
                prefix+separator+'key_pair_private_key' : key_pair_private_key,
            }
            write_db(db_conn,key_value_pairs)

    except Exception as e:
        print(f"Failed to execute main function: {e}")

if __name__ == '__main__':
    main()