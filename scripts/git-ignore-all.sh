git update-index --assume-unchanged $(g s | grep "modified:" | awk '{print $2}')
