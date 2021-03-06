cd ./terraform
~/terraform init
~/terraform validate
~/terraform apply -auto-approve


echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

echo $"[ec2-java]" > ../ansible/hosts # cria arquivo
echo "$(~/terraform output | awk '{print $3;exit}')" >> ../ansible/hosts # captura output faz split de espaco e replace de ",

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

cd ../ansible
sudo ansible-playbook -i hosts playbook.yml -u ubuntu --private-key /root/.ssh/id_rsa

echo "Aguardando execução do playbook ansible ..."
sleep 10 # 10 segundos

cd ../terraform

open "http://$(~/terraform output | awk '{print $3;exit}' | sed -e "s/\"//g")"

# *** verifica se aplicação está de pé
# sudo lsof -iTCP -sTCP:LISTEN -P | grep :3000
