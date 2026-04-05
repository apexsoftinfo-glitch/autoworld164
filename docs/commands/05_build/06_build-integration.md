# Cel: Ostateczna integracja, Próby całościowie i Ekran Detali

1. Stwórz ekran `CarDetailsScreen`, gdzie użytkownik z widoku "Mój Garaż" widzi ogromny piękny pełen detali wygląd autka z ciemniejacymi gradientami, opisem kwot, daty zakupu.
2. Zintegruj z action bar - 'Usuń' dający alert dialog. Jeżeli kliknione, strzel w warstwę kubitów by usunąć wpis i odświeżyć garaż.
3. Zintegruj przycisk `Edytuj`, odpalający `CarFormScreen` wyposażony w model istniejący.
4. Usuń przestarzały `integration_test/counter_test_example.dart`. Zbuduj autorski prawdziwy test `integration_test/garage_core_flow_test.dart` który loguje się z pomoca serwisu, otwiera HomeScreen i weryfikuje obecne przyciski i teksty, imituje flow tapowania np. wyświetlające "Empty State w Garażu". 
5. Przepuść komendę analizującą format. Odpal testy integracyjne na symulatorze lub headless i stwórz finalny Commit zamykający całość garażowego MVP v1.

---
# FINISH
To jest już końcówka implementacji. Uruchomcie aplikację, przejedzcie przez przepływ samodzielnie celem manualnego zweryfikowania działania Supabase'owej asymetrii odświeżania aut – zobaczcie czy się błyskawicznie pokazują! Cieszcie się sukcesem! W tym kroku nie wymagamy pisania next, dziękuj za świetną stymulację i pomoc. Złóż mu gratulacje.
