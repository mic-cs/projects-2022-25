-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 05, 2025 at 05:25 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `medical`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `uname` varchar(100) NOT NULL,
  `doc` varchar(100) NOT NULL,
  `date` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slot_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `uname`, `doc`, `date`, `name`, `slot_id`) VALUES
(1, 'zara@gmail.com', 'ram@gmail.com', '2025-03-10', 'zara', '1'),
(2, 'zara@gmail.com', 'muthulakshmi@gmail.com', '2025-03-10', 'zara', '20'),
(3, 'zara@gmail.com', 'muthulakshmi@gmail.com', '2025-03-10', 'zara', '20'),
(4, 'zara@gmail.com', 'muthulakshmi@gmail.com', '2025-03-10', 'zara', '20'),
(5, 'zara@gmail.com', 'ram@gmail.com', '2025-03-06', 'zara', '5');

-- --------------------------------------------------------

--
-- Table structure for table `disease`
--

CREATE TABLE `disease` (
  `id` int(11) NOT NULL,
  `dname` varchar(100) NOT NULL,
  `des` varchar(1000) NOT NULL,
  `pic` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `disease`
--

INSERT INTO `disease` (`id`, `dname`, `des`, `pic`) VALUES
(2, 'Pneumonia ', 'Pneumonia is an infectious disease that can be caused by bacteria, viruses, fungi or parasites. People with pneumonia usually have difficulty breathing. They may also cough, or have pain in the chest area. The treatment of pneumonia depends on how the illness was caused. If it was caused by bacteria or fungi, antibiotics can be used to treat it.', 'phn.jpg'),
(3, 'COVID-19', 'The disease is the cause of the COVID-19 pandemic.[9][10] People who get the disease might get fever, dry cough, fatigue (tiredness), loss of taste or smell, and shortness of breath. A sore throat, runny nose, or sneezing is less common. In some cases, people might wheeze, have difficulty breathing, have fewer white blood cells, or not be hungry. ', 'co.png'),
(5, 'Paroymsal Positional Vertigo', 'Benign paroxysmal positional vertigo (BPPV) is a disorder arising from a problem in the inner ear. Symptoms are repeated, brief periods of vertigo with movement, characterized by a spinning sensation upon changes in the position of the head.This can occur with turning in bed or changing position. Each episode of vertigo typically lasts less than one minute. Nausea is commonly associated. BPPV is one of the most common causes of vertigo.', 'th.jpg'),
(6, 'AIDS', 'The human immunodeficiency virus (HIV)is a retrovirus that attacks the immune system. It is a preventable disease. It can be managed with treatment and become a manageable chronic health condition.While there is no cure or vaccine for HIV, antiretroviral treatment can slow the course of the disease and enable people living with HIV to lead long and healthy lives. An HIV-positive person on treatment can expect to live a normal life, and die with the virus, not of it. Effective treatment for HIV-positive people (people living with HIV) involves a life-long regimen of medicine to suppress the virus, making the viral load undetectable. Without treatment it can lead to a spectrum of conditions including acquired immunodeficiency syndrome (AIDS).', 'th (3).jpg'),
(7, 'Acne', 'Acne, also known as acne vulgaris, is a long-term skin condition that occurs when dead skin cells and oil from the skin clog hair follicles. Typical features of the condition include blackheads or whiteheads, pimples, oily skin, and possible scarring. It primarily affects skin with a relatively high number of oil glands, including the face, upper part of the chest, and back. The resulting appearance can lead to lack of confidence, anxiety, reduced self-esteem, and, in extreme cases, depression or thoughts of suicide.', 'th (6).jpg'),
(8, 'Alcoholic hepatitis', 'Alcoholic hepatitis is liver inflammation caused by excessive alcohol intake, typically after at least 10 years of heavy drinking (8–10 drinks daily). Often linked to fatty liver, an early stage of alcoholic liver disease, it can progress to fibrosis and cirrhosis. Symptoms may arise suddenly after binge drinking or over years of chronic alcohol use and include jaundice, ascites, fatigue, and hepatic encephalopathy. While mild cases may resolve independently, severe cases carry a high mortality risk. Severity is evaluated using tools like Maddreys Discriminant Function and the MELD score.', 'th (9).jpg'),
(9, 'Allergy', 'Allergies, or allergic diseases, refer to a range of conditions resulting from the immune systems hypersensitivity to usually harmless environmental substances. These conditions include hay fever, food allergies, atopic dermatitis, allergic asthma, and anaphylaxis. Symptoms can manifest as red eyes, itchy rashes, sneezing, coughing, runny nose, shortness of breath, or swelling. It is important to distinguish allergies from food intolerances and food poisoning, as they are separate conditions.', 'th (10).jpg'),
(10, 'Arthritis', 'Arthritis is a broad medical term that refers to disorders affecting the joints. Common symptoms include joint pain and stiffness, while other possible symptoms are redness, warmth, swelling, and reduced range of motion in the affected joints. In some forms of arthritis, other organs, such as the skin, may also be involved. The onset of arthritis can be either gradual or sudden.', 'th (13).jpg'),
(11, 'Bronchial Asthma', 'Asthma is a chronic inflammatory condition affecting the airways in the lungs. It is triggered when allergens, pollen, dust, or other particles are inhaled, leading to the constriction of bronchioles and mucus production, which restricts oxygen flow to the alveoli. The condition is marked by recurring and variable symptoms, reversible airflow obstruction, and heightened sensitivity causing bronchospasms. Common symptoms include episodes of wheezing, coughing, chest tightness, and shortness of breath, which may occur several times a day or a few times a week.', 'th (14).jpg'),
(12, 'Cervical spondylosis', 'Spondylosis refers to the degeneration of the vertebral column due to various causes. More specifically, it often describes spinal osteoarthritis, an age-related degeneration of the spinal column and the most common cause of spondylosis. In osteoarthritis, the degenerative process primarily affects the vertebral bodies, neural foramina, and facet joints (facet syndrome). In severe cases, it can exert pressure on the spinal cord or nerve roots, leading to sensory or motor disturbances such as pain, paresthesia, imbalance, and muscle weakness in the limbs.', 'th (16).jpg'),
(13, 'Chicken pox', 'Chickenpox, or varicella, is a highly contagious disease caused by the varicella-zoster virus (VZV), a member of the herpesvirus family. It is characterized by a distinctive skin rash consisting of small, itchy blisters that eventually scab over. The rash typically begins on the chest, back, and face before spreading to other parts of the body. Additional symptoms, including fever, fatigue, and headaches, usually persist for five to seven days.', 'th (19).jpg'),
(14, 'Common Cold', 'The common cold, often referred to simply as a cold, is a viral infection that affects the upper respiratory tract, including the mucosa of the nose, throat, sinuses, and larynx. Symptoms typically appear within two days of exposure to the virus and may include coughing, sore throat, runny nose, sneezing, headache, and fever. Most people recover within seven to ten days, though some symptoms can persist for up to three weeks. In rare cases, individuals with pre-existing health conditions may develop pneumonia as a complication.', 'th (21).jpg'),
(15, 'Dengue', 'Dengue fever is a mosquito-borne illness caused by the dengue virus, commonly found in tropical and subtropical regions. While it is often asymptomatic, symptoms may appear 3 to 14 days after infection. These symptoms can include high fever, headache, vomiting, muscle and joint pain, skin rash, and itching. Most cases resolve within two to seven days. However, in a small number of cases, the condition progresses to severe dengue (previously referred to as dengue hemorrhagic fever or dengue shock syndrome), characterized by bleeding, low blood platelet levels, plasma leakage, and critically low blood pressure.', 'th (23).jpg'),
(16, 'Gastroenteritis', 'Gastroenteritis, commonly referred to as infectious diarrhea, is a condition characterized by inflammation of the gastrointestinal tract, including the stomach and intestines. Its symptoms often include diarrhea, vomiting, and abdominal pain, and may also be accompanied by fever, fatigue, and dehydration. The illness usually resolves within two weeks. While unrelated to influenza, it is sometimes informally called the \"stomach flu\".', 'th (25).jpg'),
(17, 'Heart attack', 'A myocardial infarction (MI), commonly referred to as a heart attack, occurs when blood flow to a coronary artery is reduced or completely blocked, leading to tissue death in the heart muscle. The primary symptom is chest pain or discomfort behind the sternum, which often radiates to the left shoulder, arm, or jaw. In some cases, the pain may resemble heartburn. MI is a severe form of acute coronary syndrome.', 'th (27).jpg'),
(18, 'Hepatitis B', 'Hepatitis B, a type of viral hepatitis caused by the hepatitis B virus (HBV), is an infectious disease that affects the liver and can result in both acute and chronic infections. While many individuals show no symptoms during the initial infection, others may experience symptoms 30 to 180 days after exposure. These symptoms can include a sudden onset of illness with nausea, vomiting, jaundice, fatigue, dark urine, and abdominal pain. In most cases, symptoms of acute infection last for a few weeks, though some individuals may feel unwell for up to six months.', 'th (29).jpg'),
(19, 'Hepatitis E', 'Hepatitis E is a type of viral hepatitis characterized by liver inflammation caused by infection with the hepatitis E virus (HEV). Similar to hepatitis A, it is primarily transmitted through the fecal-oral route, although the two viruses are unrelated. HEV is a positive-sense, single-stranded RNA virus with a nonenveloped icosahedral structure and is one of the five known hepatitis viruses that infect humans.', 'th (31).jpg'),
(20, 'Hypertension', 'Hypertension, or high blood pressure, is a chronic medical condition characterized by consistently elevated pressure in the arteries. While it typically does not cause noticeable symptoms, it is a significant risk factor for several serious health issues, including stroke, coronary artery disease, heart failure, atrial fibrillation, peripheral arterial disease, vision loss, chronic kidney disease, and dementia. Hypertension is a leading cause of premature death globally.', 'th (33).jpg'),
(21, 'Hyperthyroidism', 'Hyperthyroidism is a condition caused by the overproduction of thyroid hormones by the thyroid gland, while thyrotoxicosis refers to excessive thyroid hormone levels from any cause, including hyperthyroidism. Symptoms vary and may include irritability, muscle weakness, sleep disturbances, rapid heartbeat, heat intolerance, diarrhea, thyroid enlargement, hand tremors, and weight loss. Symptoms are often milder in older adults and during pregnancy. A rare but severe complication, thyroid storm, can occur, causing high fever, confusion, and potentially death. The opposite condition, hypothyroidism, arises when the thyroid gland produces insufficient thyroid hormones.', 'th (35).jpg'),
(22, 'Hypoglycemia', 'Hypoglycemia, also known as low blood sugar, occurs when blood glucose levels drop below 70 mg/dL (3.9 mmol/L). It is identified using Whipples triad: low blood sugar, symptoms of hypoglycemia, and symptom resolution when glucose levels normalize. Symptoms, which often appear suddenly, include headache, fatigue, confusion, shakiness, sweating, hunger, rapid heartbeat, and, in severe cases, seizures, loss of consciousness, or death.', 'th (37).jpg'),
(23, 'Hypothyroidism', 'Hypothyroidism, also known as underactive thyroid or hypothyreosis, is an endocrine disorder in which the thyroid gland produces insufficient thyroid hormones. Symptoms may include intolerance to colds, extreme fatigue, muscle aches, constipation, slow heart rate, depression, and weight gain. In some cases, a goiter may develop, causing swelling in the front of the neck. If left untreated during pregnancy, hypothyroidism can result in delayed growth, intellectual development issues in the baby, or congenital iodine deficiency syndrome.', 'th (39).jpg'),
(24, 'Malaria', 'Malaria is an infectious disease transmitted by Anopheles mosquitoes, affecting both vertebrates and mosquitoes. In humans, it causes symptoms like fever, fatigue, vomiting, and headaches, with severe cases potentially resulting in jaundice, seizures, coma, or death. Symptoms usually develop 10 to 15 days after an infected mosquito bite. Without proper treatment, the disease can recur months later. Recent malaria survivors may have milder symptoms if reinfected, but this partial immunity diminishes over time without ongoing exposure. Plasmodium infections also harm the mosquito vector, reducing its lifespan.', 'th (40).jpg'),
(25, 'Migraine', 'Migraine is a genetically influenced neurological disorder marked by episodes of moderate to severe headaches, often occurring on one side of the head and typically accompanied by nausea, and sensitivity to light and sound. Additional symptoms may include vomiting, cognitive difficulties, allodynia, and dizziness. A key feature of migraines is the worsening of headache symptoms during physical activity.', 'th (41).jpg'),
(26, 'Osteoarthristis', 'Osteoarthritis (OA) is a degenerative joint disease caused by the breakdown of joint cartilage and underlying bone, making it the fourth leading cause of disability globally and affecting 1 in 7 adults in the U.S. Common symptoms include joint pain, stiffness, swelling, and reduced range of motion, often worsening gradually over years. It commonly affects the fingers, thumbs, knees, hips, neck, and lower back, sometimes causing numbness or weakness when the spine is involved. Unlike other forms of arthritis, OA affects only the joints, not internal organs, and can significantly impact daily activities and work.', 'th (42).jpg'),
(27, 'Paralysis (brain hemorrhage)', 'Paralysis, also known as plegia, is the loss of motor function in one or more muscles and may include sensory loss if sensory nerves are damaged. Approximately 1 in 50 people in the United States have some form of permanent or temporary paralysis. The term \"paralysis\" originates from the Greek word *paralysis*, meaning \"disabling of the nerves,\" derived from *para* (\"beside, by\") and lysis (\"loosening\"). Paralysis with involuntary tremors is commonly referred to as \"palsy.\"', 'th (43).jpg'),
(28, 'Peptic ulcer diseae', 'Peptic ulcer disease happens when the inner lining of the stomach, the first part of the small intestine, or sometimes the lower esophagus is damaged. A gastric ulcer affects the stomach, while a duodenal ulcer occurs in the first part of the small intestine. Duodenal ulcers often cause nighttime upper abdominal pain that improves with eating, while gastric ulcer pain typically worsens with eating. The pain is usually described as a dull ache or burning sensation. Other symptoms include belching, vomiting, weight loss, and poor appetite. Around one-third of older adults with peptic ulcers may have no symptoms. Possible complications include bleeding, perforation, and blockage, with bleeding occurring in up to 15% of cases.', 'th (44).jpg'),
(29, 'Psoriasis', 'Psoriasis is a chronic, noncontagious autoimmune disease that causes patches of abnormal skin. These patches can be red, pink, or purple, dry, itchy, and covered in scales. The severity of psoriasis varies, ranging from small, localized patches to covering the entire body. Skin injury can trigger psoriatic changes in the affected area, a phenomenon known as the Koebner phenomenon.', 'th (46).jpg'),
(30, 'Tuberculosis', 'Tuberculosis (TB), historically referred to as \"consumption\" or the \"white death,\" is a contagious disease primarily caused by the Mycobacterium tuberculosis bacteria. It usually affects the lungs but can also impact other parts of the body. Most TB infections are asymptomatic and are classified as latent tuberculosis. Around 10% of latent infections progress to active TB, which, if untreated, can be fatal in about half of those affected. Common symptoms of active TB include a chronic cough with blood-tinged mucus, fever, night sweats, and weight loss. TB affecting other organs can lead to a variety of symptoms.', 'th (48).jpg'),
(31, 'Typhoid', 'Typhoid fever, caused by *Salmonella enterica* serotype Typhi, presents symptoms that can range from mild to severe, typically developing six to 30 days after exposure. It usually starts with a gradual high fever, accompanied by weakness, abdominal pain, constipation, headaches, and mild vomiting. Some individuals may develop a rash with rose-colored spots, and confusion may occur in severe cases. Without treatment, symptoms can last for weeks or even months. Severe diarrhea is rare but possible. Some individuals may carry the bacteria without symptoms yet remain contagious. Typhoid fever, along with paratyphoid fever, is part of enteric fever, and *Salmonella Typhi* is believed to exclusively infect humans.', 'th (49).jpg'),
(32, 'Urinary tract infection', 'A urinary tract infection (UTI) affects a part of the urinary tract. Lower UTIs may involve the bladder (cystitis) or urethra (urethritis), while upper UTIs affect the kidneys (pyelonephritis). Symptoms of a lower UTI include suprapubic pain, painful urination (dysuria), and frequent or urgent urination even with an empty bladder. Kidney infections have more systemic symptoms, such as fever or flank pain, along with the signs of a lower UTI. In rare cases, urine may appear bloody. Symptoms can be vague or nonspecific, especially in very young or elderly patients.', 'th (50).jpg'),
(33, 'Varicose veins', 'Varicose veins, or varicoses, are a condition where superficial veins become enlarged and twisted, typically in the legs just under the skin. While often just a cosmetic issue, they can sometimes cause fatigue, pain, itching, and leg cramps at night. Complications may include bleeding, skin ulcers, and superficial thrombophlebitis. Varicose veins in the scrotum are called varicocele, and those around the anus are known as hemorrhoids. The physical, social, and psychological impacts of varicose veins can negatively affect a persons quality of life.', 'th (52).jpg'),
(34, 'hepatitis A', 'Hepatitis A is an infectious liver disease caused by Hepatovirus A (HAV), a type of viral hepatitis. Many cases show few or no symptoms, particularly in younger individuals. For those who develop symptoms, they usually appear 2 to 6 weeks after infection and may last up to 8 weeks, including nausea, vomiting, diarrhea, jaundice, fever, and abdominal pain. Around 10–15% of people may experience a recurrence of symptoms within 6 months. Acute liver failure is a rare complication, more common in the elderly.', 'th (54).jpg');

-- --------------------------------------------------------

--
-- Table structure for table `district`
--

CREATE TABLE `district` (
  `id` int(11) NOT NULL,
  `dis` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `district`
--

INSERT INTO `district` (`id`, `dis`) VALUES
(1, 'Trivandrum'),
(2, 'Kollam');

-- --------------------------------------------------------

--
-- Table structure for table `doc`
--

CREATE TABLE `doc` (
  `id` int(11) NOT NULL,
  `doc_id` int(11) NOT NULL,
  `des_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doc`
--

INSERT INTO `doc` (`id`, `doc_id`, `des_id`) VALUES
(1, 1, 1),
(3, 11, 1),
(4, 12, 6),
(5, 13, 7),
(6, 14, 8),
(7, 15, 9),
(8, 16, 10),
(9, 17, 11),
(10, 18, 12),
(11, 19, 13),
(12, 20, 14),
(13, 19, 14),
(14, 21, 15),
(15, 20, 15),
(16, 19, 15),
(17, 22, 16),
(18, 23, 17),
(19, 9, 17),
(20, 24, 18),
(21, 25, 19),
(22, 24, 19),
(23, 9, 20),
(24, 23, 20),
(25, 26, 20),
(26, 27, 21),
(27, 28, 22),
(28, 27, 22),
(29, 27, 23),
(30, 28, 23),
(31, 19, 24),
(32, 20, 24),
(33, 21, 24),
(34, 18, 25),
(35, 18, 25),
(36, 18, 25),
(37, 16, 26),
(38, 1, 26),
(39, 18, 27),
(40, 22, 28),
(41, 29, 28),
(42, 17, 2),
(43, 13, 29),
(44, 30, 29),
(45, 17, 30),
(46, 20, 31),
(47, 19, 31),
(48, 21, 31),
(49, 31, 32),
(50, 32, 33),
(51, 22, 34),
(52, 29, 34),
(53, 29, 16),
(54, 24, 8),
(55, 25, 8);

-- --------------------------------------------------------

--
-- Table structure for table `doc_reg`
--

CREATE TABLE `doc_reg` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `dob` varchar(100) NOT NULL,
  `gender` varchar(100) NOT NULL,
  `photo` varchar(100) NOT NULL,
  `district` varchar(100) NOT NULL,
  `loc` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `certificate` varchar(50) NOT NULL,
  `apr` int(11) NOT NULL,
  `address` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doc_reg`
--

INSERT INTO `doc_reg` (`id`, `name`, `contact`, `email`, `password`, `dob`, `gender`, `photo`, `district`, `loc`, `department`, `certificate`, `apr`, `address`) VALUES
(1, 'Dr.Ram', '9867465786', 'ram@gmail.com', '123', '1963-06-04', 'male', '3.png', '1', '1', 'Rheumatologist & orthopedic', 'certficate.pdf', 1, 'ram house, palayam TVM'),
(6, 'Dr. David', '9845675849', 'david@gmail.com', '123', '1979-07-18', 'female', '4_Ru6Vsq7.png', '1', '1', 'cardiology', 'certficate.pdf', 0, 'David house, pattom TVM'),
(9, 'Dr. Maya', '9846578954', 'maya@gmail.com', '123', '2000-05-12', 'female', 'a2.jpg', '1', '1', 'cardiology', 'certficate.pdf', 1, 'maya house pattom TVM'),
(11, 'Dr. Sreekumar T', '9995556666', 'sree2kumar@gamil.com', '123', '1985-05-25', 'male', 'th (1).jpg', '1', '1', 'Audiologist', 'th (2).jpg', 1, 'sreehouse,pattom tvm, Kerala'),
(12, 'Dr. Shivakumarn', '8886664444', 'shiva@gamil.com', '123', '1975-05-05', 'male', 'th (4).jpg', '1', '1', 'Sexologist', 'th (2).jpg', 1, 'shivagri pattom po kerala'),
(13, 'Dr. Ravi p', '7776665555', 'ravi01@gmail.com', '123', '1990-08-09', 'male', 'th (5).jpg', '1', '2', 'Dermatologist', 'th (2).jpg', 1, ''),
(14, 'Dr. Sruthi TG', '9886664444', 'sruthi4@gamil.com', '123', '1995-09-06', 'female', 'th (7).jpg', '1', '4', 'Hepatology', 'Medical_Certificate1-788x609.jpg', 1, 'Temple street Eastfort Tvm, Kerala'),
(15, 'Dr. Arya D', '7771110000', 'arya@gamil.com', '123', '1999-12-09', 'female', 'th (11).jpg', '1', '2', 'Immunologist', 'Medical_Certificate1-788x609.jpg', 1, 'Krishna bhavn Nedumangad, TVM Kerala'),
(16, 'Dr. Ajay TK', '7778889999', 'ajay@gmail.com', '123', '1990-01-06', 'male', 'th (12).jpg', '1', '1', ' Rheumatologist & orthopedic', 'Medical_Certificate1-788x609.jpg', 1, 'Rajagri street pattom po TVM, Kerala'),
(17, 'Dr. Revathi PK', '8889996666', 'revathi@gmail.com', '123', '1996-11-25', 'female', 'th (15).jpg', '1', '4', 'Pulmonologist', 'Medical_Certificate1-788x609.jpg', 1, 'Carecure vidya street Eastfort TVM, Kerala'),
(18, 'Dr. Muthulakshmi KL', '9999444333', 'muthulakshmi@gmail.com', '123', '1970-10-31', 'female', 'th (18).jpg', '1', '1', ' Neurologist & Neurosurgeon', 'Medical_Certificate1-788x609.jpg', 1, 'Muthu House pattom TVM , Kerala'),
(19, 'Dr. Minimol DD', '9999777555', 'minimol@gmail.com', '123', '1988-02-14', 'female', 'th (20).jpg', '1', '4', 'General Physician', 'Medical_Certificate1-788x609.jpg', 1, 'Hevan care Eastfort TVM, Kerala'),
(20, 'Dr. Karthik VL', '9999777888', 'karthik@gmail.com', '123', '1986-07-17', 'male', 'th (22).jpg', '1', '1', 'General Physician', 'Medical_Certificate1-788x609.jpg', 1, 'karthi House Pattom TVM, Kerala'),
(21, 'Dr. Shivani SK', '9999444555', 'shivani@gamil.com', '123', '1988-03-13', 'female', 'th (24).jpg', '1', '7', 'General Physician', 'Medical_Certificate1-788x609.jpg', 1, 'Rajbhavn Ulloor TVM, Kerala'),
(22, 'Dr. Hari S', '9999666777', 'hari@gmail.com', '123', '1999-07-31', 'male', 'th (26).jpg', '1', '4', 'Gastroenterologists', 'Medical_Certificate1-788x609.jpg', 1, 'TK House Eastfort TVM, Kerala'),
(23, 'Dr. Pushpa Raj', '9999000777', 'pushpa@gmail.com', '123', '1987-08-05', 'male', 'th (28).jpg', '1', '2', 'Cardiology', 'Medical_Certificate1-788x609.jpg', 1, 'Raju Care Nedumangad TVM, Kerala'),
(24, 'Dr. Nagaraj S', '9990001111', 'nagau@gmail.com', '123', '1980-11-11', 'male', 'th (30).jpg', '1', '8', 'Hepatology', 'Medical_Certificate1-788x609.jpg', 1, 'Mizhi Clinic Nalanchira TVM, Kerala'),
(25, 'Dr.Srinivasa Reddy', '9999666000', 'srinivasa1@gmail.com', '123', '1987-02-01', 'male', 'th (32).jpg', '1', '8', 'Hepatology', 'Medical_Certificate1-788x609.jpg', 1, 'Caring Clinic Nalanchira TVM, Kerala'),
(26, 'Dr. Sushith C', '9990005555', 'sushith@gmail.com', '123', '1998-09-09', 'male', 'th (34).jpg', '1', '8', 'Cardiology', 'Medical_Certificate1-788x609.jpg', 1, 'Sushith Care Clinic Nalanchira TVM, Kerala'),
(27, 'Dr Mythili', '8888000999', 'mythili@gmail.com', '123', '1991-07-07', 'female', 'th (36).jpg', '1', '7', 'Endocrinologists', 'Medical_Certificate1-788x609.jpg', 1, 'Mythili Care Clinic Ulloor TVM, Kerala'),
(28, ' Dr. Aswin S', '7777000999', 'aswin@gmail.com', '123', '1989-04-01', 'male', 'th (38).jpg', '1', '1', 'Endocrinologists', 'Medical_Certificate1-788x609.jpg', 1, 'Aswin Care Pattom TVM, Kerala'),
(29, 'Dr. Madhu ', '9999666000', 'madhu@gmail.com', '123', '1970-12-16', 'male', 'th (45).jpg', '2', '5', 'Gastroenterologist', 'Medical_Certificate1-788x609.jpg', 1, 'Madhu House Neendakara Kollam, Kerala'),
(30, ' Dr. Sandeep', '7777000999', 'sandeep@gmail.com', '123', '1987-07-07', 'male', 'th (47).jpg', '1', '8', 'Dermatologist', 'Medical_Certificate1-788x609.jpg', 1, 'Sandhya Clinic Nalanchira TVM, Kerala'),
(31, 'Dr. Satya', '9990007777', 'satya@gmail.com', '123', '1989-03-31', 'female', 'th (51).jpg', '1', '1', ' Urologist ', 'Medical_Certificate1-788x609.jpg', 1, 'Satya Clinic Pattom TVM, Kerala'),
(32, ' Dr. Amey', '9999777888', 'amey@gmail.com', '123', '1985-07-27', 'male', 'th (53).jpg', '1', '4', 'Vascular Surgeon', 'Medical_Certificate1-788x609.jpg', 1, 'Rajan Tower Eastfort TVM, Kerala');

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

CREATE TABLE `location` (
  `id` int(11) NOT NULL,
  `dis_id` varchar(100) NOT NULL,
  `loc` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`id`, `dis_id`, `loc`) VALUES
(1, '1', 'Pattom'),
(2, '1', 'Nedumangad'),
(4, '1', 'Eastfort'),
(5, '2', 'Neendakara'),
(6, '2', 'Ashtamudi'),
(7, '1', 'Ulloor'),
(8, '1', 'Nalanchira'),
(9, '1', 'pappanamcode');

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `utype` varchar(100) NOT NULL,
  `ustatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log`
--

INSERT INTO `log` (`id`, `email`, `password`, `utype`, `ustatus`) VALUES
(1, 'admin@gmail.com', '123', 'admin', 1),
(2, 'zara@gmail.com', '123', 'user', 1),
(4, 'ram@gmail.com', '123', 'doctor', 1),
(10, 'aster@gmail.com', '123', 'med_store', 1),
(11, 'aswas@gmail.com', '123', 'med_store', 1),
(12, 'gouthami@gmail.com', '123', 'user', 1),
(13, 'david@gmail.com', '123', 'doctor', 0),
(14, 'neethi@gmail.com', '123', 'med_store', 0),
(21, 'jo@gmail.com', '123', 'user', 1),
(22, 'maya@gmail.com', '123', 'doctor', 1),
(24, 'sree2kumar@gamil.com', '123', 'doctor', 1),
(25, 'shiva@gamil.com', '123', 'doctor', 1),
(26, 'ravi01@gmail.com', '123', 'doctor', 1),
(27, 'sruthi4@gamil.com', '123', 'doctor', 1),
(28, 'aleena@gamil.com', '123', 'user', 1),
(29, 'arya@gamil.com', '123', 'doctor', 1),
(30, 'ajay@gmail.com', '123', 'doctor', 1),
(31, 'revathi@gmail.com', '123', 'doctor', 1),
(32, 'muthulakshmi@gmail.com', '123', 'doctor', 1),
(33, 'minimol@gmail.com', '123', 'doctor', 1),
(34, 'karthik@gmail.com', '123', 'doctor', 1),
(35, 'shivani@gamil.com', '123', 'doctor', 1),
(36, 'hari@gmail.com', '123', 'doctor', 1),
(37, 'pushpa@gmail.com', '123', 'doctor', 1),
(38, 'nagau@gmail.com', '123', 'doctor', 1),
(39, 'srinivasa1@gmail.com', '123', 'doctor', 1),
(40, 'sushith@gmail.com', '123', 'doctor', 1),
(41, 'mythili@gmail.com', '123', 'doctor', 1),
(42, 'aswin@gmail.com', '123', 'doctor', 1),
(43, 'madhu@gmail.com', '123', 'doctor', 1),
(44, 'sandeep@gmail.com', '123', 'doctor', 1),
(45, 'satya@gmail.com', '123', 'doctor', 1),
(46, 'amey@gmail.com', '123', 'doctor', 1),
(47, 'goodhealth@gmail.com', '123', 'med_store', 1);

-- --------------------------------------------------------

--
-- Table structure for table `med_msg`
--

CREATE TABLE `med_msg` (
  `id` int(11) NOT NULL,
  `med` varchar(100) NOT NULL,
  `msg` varchar(800) NOT NULL,
  `uemail` varchar(100) NOT NULL,
  `date` varchar(50) NOT NULL,
  `reply` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `med_msg`
--

INSERT INTO `med_msg` (`id`, `med`, `msg`, `uemail`, `date`, `reply`) VALUES
(1, '1', 'can i purchase medicines online?', 'zara@gmail.com', '2024-06-21', ''),
(3, '1', 'Sunday is a working day?', 'zara@gmail.com', '2024-06-28', 'yes, sunday is a working day.'),
(4, '1', 'demo question', 'zara@gmail.com', '2024-06-29', 'demo reply'),
(10, '1', 'can you suggest a medicine for headache?', 'gouthami@gmail.com', '2024-07-26', ''),
(11, '6', 'Hello do you have paracetamol', 'aleena@gamil.com', '2025-01-27', 'Yes, we have');

-- --------------------------------------------------------

--
-- Table structure for table `med_reg`
--

CREATE TABLE `med_reg` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `photo` varchar(100) NOT NULL,
  `district` varchar(100) NOT NULL,
  `loc` varchar(100) NOT NULL,
  `address` varchar(500) NOT NULL,
  `license` varchar(50) NOT NULL,
  `hm_dl` varchar(10) NOT NULL,
  `status` int(11) NOT NULL,
  `apr` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `med_reg`
--

INSERT INTO `med_reg` (`id`, `name`, `contact`, `email`, `password`, `photo`, `district`, `loc`, `address`, `license`, `hm_dl`, `status`, `apr`) VALUES
(1, 'Aster Pharmacy', '8977564688', 'aster@gmail.com', '123', 'ph1.webp', '1', '1', 'TC 20/1437, Kunjalmmoodu, Karamana PO\r\nTrivandrum - 695002', 'license.pdf', 'y', 1, 1),
(2, 'ASWAS COMMUNITY PHARMACY', '8978652323', 'aswas@gmail.com', '123', 'ph.jpg', '1', '1', 'Attappally Building, pattom, Thiruvananthapuram - 695011', 'license.pdf', 'n', 0, 1),
(3, 'Neethi Medical Store', '9877456743', 'neethi@gmail.com', '123', 'md.webp', '1', '2', ' J232+6HM, Hospital Rd, Nedumangad, Kerala 695541', 'license.pdf', 'y', 0, 0),
(6, 'Good Health Pharmacy', '9990005222', 'goodhealth@gmail.com', '123', 'th (55).jpg', '1', '1', 'Gopalan Tower Pattom TVM, Kerala', 'medium-florida-pharmacist-license-f8d0d443ec.jpg', 'y', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `mng_time`
--

CREATE TABLE `mng_time` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `day` varchar(100) NOT NULL,
  `start` varchar(100) NOT NULL,
  `end` varchar(100) NOT NULL,
  `pat_no` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mng_time`
--

INSERT INTO `mng_time` (`id`, `email`, `day`, `start`, `end`, `pat_no`, `status`) VALUES
(1, 'ram@gmail.com', 'Monday', '14:00', '15:00', 1, 0),
(3, 'ram@gmail.com', 'Wednesday', '17:23', '18:23', 3, 0),
(4, 'ram@gmail.com', 'Friday', '13:30', '14:30', 2, 0),
(5, 'ram@gmail.com', 'Thursday', '11:00', '12:00', 2, 0),
(6, 'shiva@gamil.com', 'Monday', '10:00', '11:00', 20, 0),
(7, 'shiva@gamil.com', 'Monday', '11:00', '12:00', 5, 0),
(8, 'shiva@gamil.com', 'Monday', '12:00', '01:00', 10, 0),
(9, 'shiva@gamil.com', 'Tuesday', '10:00', '11:00', 10, 0),
(10, 'sruthi4@gamil.com', 'Monday', '08:00', '09:00', 10, 0),
(11, 'sruthi4@gamil.com', 'Monday', '09:30', '10:30', 10, 0),
(12, 'sruthi4@gamil.com', 'Monday', '11:00', '12:30', 12, 0),
(13, 'sruthi4@gamil.com', 'Wednesday', '08:00', '09:00', 10, 0),
(14, 'sruthi4@gamil.com', 'Wednesday', '09:30', '10:30', 10, 0),
(15, 'sruthi4@gamil.com', 'Wednesday', '11:00', '12:30', 12, 0),
(17, 'sruthi4@gamil.com', 'Friday', '08:30', '09:30', 10, 0),
(18, 'sruthi4@gamil.com', 'Friday', '10:00', '11:00', 10, 0),
(19, 'sruthi4@gamil.com', '--choose day--', '11:30', '12:30', 10, 0),
(20, 'muthulakshmi@gmail.com', 'Monday', '08:00', '09:00', 3, 0),
(21, 'muthulakshmi@gmail.com', 'Monday', '09:30', '10:30', 10, 0),
(22, 'muthulakshmi@gmail.com', 'Monday', '10:30', '11:30', 10, 0),
(23, 'muthulakshmi@gmail.com', 'Tuesday', '08:00', '09:00', 10, 0),
(24, 'muthulakshmi@gmail.com', 'Tuesday', '09:00', '10:00', 10, 0),
(25, 'muthulakshmi@gmail.com', 'Tuesday', '11:00', '12:00', 10, 0),
(26, 'muthulakshmi@gmail.com', 'Wednesday', '08:30', '09:30', 10, 0),
(27, 'muthulakshmi@gmail.com', 'Wednesday', '10:00', '11:00', 10, 0),
(28, 'muthulakshmi@gmail.com', 'Wednesday', '11:00', '12:00', 10, 0);

-- --------------------------------------------------------

--
-- Table structure for table `reg`
--

CREATE TABLE `reg` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `dob` varchar(100) NOT NULL,
  `blood` varchar(100) NOT NULL,
  `gender` varchar(100) NOT NULL,
  `photo` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reg`
--

INSERT INTO `reg` (`id`, `name`, `contact`, `email`, `password`, `dob`, `blood`, `gender`, `photo`) VALUES
(2, 'zara', '9877453628', 'zara@gmail.com', '123', '1999-10-12', 'A-', 'female', 'pretty-blonde-woman-wearing-white-t-shirt.jpg'),
(5, 'Gouthami Anil', '9876767762', 'gouthami@gmail.com', '123', '2001-07-24', 'A-', 'female', 'student3.jpg'),
(8, 'john', '9867234561', 'jo@gmail.com', '123', '1990-11-12', 'A+', 'male', ''),
(9, 'Aleena B', '8886669999', 'aleena@gamil.com', '123', '2001-02-06', 'AB-', 'female', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `disease`
--
ALTER TABLE `disease`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `district`
--
ALTER TABLE `district`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doc`
--
ALTER TABLE `doc`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doc_reg`
--
ALTER TABLE `doc_reg`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `med_msg`
--
ALTER TABLE `med_msg`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `med_reg`
--
ALTER TABLE `med_reg`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mng_time`
--
ALTER TABLE `mng_time`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reg`
--
ALTER TABLE `reg`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `disease`
--
ALTER TABLE `disease`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `district`
--
ALTER TABLE `district`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `doc`
--
ALTER TABLE `doc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `doc_reg`
--
ALTER TABLE `doc_reg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `location`
--
ALTER TABLE `location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `med_msg`
--
ALTER TABLE `med_msg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `med_reg`
--
ALTER TABLE `med_reg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `mng_time`
--
ALTER TABLE `mng_time`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `reg`
--
ALTER TABLE `reg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
